import 'dart:async';

import 'package:eng_card/app/providers.dart';
import 'package:eng_card/core/enums.dart';
import 'package:eng_card/data/repositories/card_repository.dart';
import 'package:eng_card/data/repositories/deck_repository.dart';
import 'package:eng_card/data/repositories/study_session_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudyViewState {
  const StudyViewState({
    required this.mode,
    required this.sessionData,
    required this.virtualPage,
    required this.revealedCardIds,
  });

  final StudyMode mode;
  final ActiveSessionData? sessionData;
  final int virtualPage;
  final Set<int> revealedCardIds;

  StudyViewState copyWith({
    StudyMode? mode,
    ActiveSessionData? sessionData,
    bool clearSession = false,
    int? virtualPage,
    Set<int>? revealedCardIds,
  }) {
    return StudyViewState(
      mode: mode ?? this.mode,
      sessionData: clearSession ? null : (sessionData ?? this.sessionData),
      virtualPage: virtualPage ?? this.virtualPage,
      revealedCardIds: revealedCardIds ?? this.revealedCardIds,
    );
  }

  SessionCardView? get currentCard {
    if (sessionData == null) {
      return null;
    }
    final active = sessionData!.activeCards;
    if (active.isEmpty) {
      return null;
    }
    return active[virtualPage % active.length];
  }

  bool get hasActiveSession => sessionData != null && !sessionData!.isCompleted;

  bool get isExamMode => mode == StudyMode.exam;

  bool isAnswerVisible(int cardId) {
    if (!isExamMode) {
      return true;
    }
    return revealedCardIds.contains(cardId);
  }
}

final studyControllerProvider =
    StateNotifierProvider.autoDispose<
      StudyController,
      AsyncValue<StudyViewState>
    >((ref) {
      return StudyController(ref);
    });

class StudyController extends StateNotifier<AsyncValue<StudyViewState>> {
  StudyController(this.ref) : super(const AsyncValue.loading()) {
    _load();
  }

  final Ref ref;

  DeckRepository get _deckRepo => ref.read(deckRepositoryProvider);
  CardRepository get _cardRepo => ref.read(cardRepositoryProvider);
  StudySessionRepository get _sessionRepo =>
      ref.read(sessionRepositoryProvider);

  Future<void> _load() async {
    final settings = ref.read(settingsControllerProvider).valueOrNull;
    final defaultMode = settings?.defaultStudyMode ?? StudyMode.practice;
    final active = await _sessionRepo.loadActiveSession();
    final mode = active == null
        ? defaultMode
        : StudyMode.values[active.session.mode];
    state = AsyncValue.data(
      StudyViewState(
        mode: mode,
        sessionData: active,
        virtualPage: 1000,
        revealedCardIds: <int>{},
      ),
    );
  }

  Future<void> reload() => _load();

  Future<void> toggleMode() async {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }
    final nextMode = current.mode == StudyMode.practice
        ? StudyMode.exam
        : StudyMode.practice;
    state = AsyncValue.data(current.copyWith(mode: nextMode));
  }

  Future<void> createSession({
    required SessionSource source,
    required int requestedCount,
    required List<int> manualCardIds,
    required List<int> deckIds,
  }) async {
    final previous = state.valueOrNull;
    final mode = previous?.mode ?? StudyMode.practice;
    state = const AsyncValue.loading();

    try {
      final result = await _sessionRepo.createSession(
        SessionCreateRequest(
          sourceDeckIds: deckIds,
          source: source,
          requestedCount: requestedCount,
          manualCardIds: manualCardIds,
          mode: mode,
        ),
      );

      if (result.sessionId < 0) {
        state = AsyncValue.data(
          StudyViewState(
            mode: mode,
            sessionData: null,
            virtualPage: 1000,
            revealedCardIds: <int>{},
          ),
        );
        return;
      }

      await _cardRepo.incrementSelectionCounts(result.selectedCardIds);
      for (final entry in result.nextSequentialCursors.entries) {
        await _deckRepo.updateSequentialCursor(entry.key, entry.value);
      }

      final loaded = await _sessionRepo.loadSession(result.sessionId);
      state = AsyncValue.data(
        StudyViewState(
          mode: mode,
          sessionData: loaded,
          virtualPage: 1000,
          revealedCardIds: <int>{},
        ),
      );
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> onPageChanged(int page) async {
    final current = state.valueOrNull;
    if (current == null || current.sessionData == null) {
      return;
    }

    final activeCount = current.sessionData!.activeCards.length;
    if (activeCount == 0) {
      return;
    }

    final normalized = page % activeCount;
    final shouldClearRevealed =
        current.isExamMode && current.revealedCardIds.isNotEmpty;
    state = AsyncValue.data(
      current.copyWith(
        virtualPage: page,
        revealedCardIds: shouldClearRevealed
            ? <int>{}
            : current.revealedCardIds,
      ),
    );
    unawaited(
      _sessionRepo
          .updateSessionIndex(current.sessionData!.session.id, normalized)
          .catchError((_) {}),
    );
  }

  Future<void> revealAnswer() async {
    final current = state.valueOrNull;
    final card = current?.currentCard;
    final session = current?.sessionData;
    if (current == null || card == null || session == null) {
      return;
    }

    if (!current.isExamMode || current.revealedCardIds.contains(card.cardId)) {
      return;
    }

    final nextRevealed = Set<int>.from(current.revealedCardIds)
      ..add(card.cardId);
    state = AsyncValue.data(current.copyWith(revealedCardIds: nextRevealed));

    await _sessionRepo.logReveal(
      sessionId: session.session.id,
      sessionCardId: card.sessionCardId,
    );
  }

  Future<void> resetCurrentCard() async {
    final current = state.valueOrNull;
    final card = current?.currentCard;
    final session = current?.sessionData;
    if (current == null || card == null || session == null) {
      return;
    }

    await _cardRepo.incrementResetCount(card.cardId);
    await _sessionRepo.logReset(
      sessionId: session.session.id,
      sessionCardId: card.sessionCardId,
    );
  }

  Future<void> overCurrentCard() async {
    final current = state.valueOrNull;
    final card = current?.currentCard;
    if (current == null || card == null) {
      return;
    }
    await overCard(sessionCardId: card.sessionCardId, cardId: card.cardId);
  }

  Future<void> overCard({
    required int sessionCardId,
    required int cardId,
    int? nextVirtualPage,
  }) async {
    final current = state.valueOrNull;
    final session = current?.sessionData;
    if (current == null || session == null) {
      return;
    }

    final optimisticCards = session.cards
        .map(
          (item) => item.sessionCardId == sessionCardId
              ? SessionCardView(
                  sessionCardId: item.sessionCardId,
                  cardId: item.cardId,
                  sourceDeckId: item.sourceDeckId,
                  title: item.title,
                  answer: item.answer,
                  displayOrder: item.displayOrder,
                  isOver: true,
                )
              : item,
        )
        .toList();
    final optimisticSession = ActiveSessionData(
      session: session.session,
      sourceDeckIds: session.sourceDeckIds,
      cards: optimisticCards,
    );
    final resolvedVirtualPage = nextVirtualPage ?? current.virtualPage;
    final optimisticActiveCount = optimisticSession.activeCards.length;
    final optimisticState = current.copyWith(
      sessionData: optimisticSession,
      virtualPage: resolvedVirtualPage,
      revealedCardIds: Set<int>.from(current.revealedCardIds)..remove(cardId),
    );

    state = AsyncValue.data(optimisticState);
    unawaited(
      _persistOverCard(
        previousState: current,
        optimisticState: optimisticState,
        sessionId: session.session.id,
        sessionCardId: sessionCardId,
        cardId: cardId,
        activeCount: optimisticActiveCount,
        virtualPage: resolvedVirtualPage,
      ),
    );
  }

  Future<void> _persistOverCard({
    required StudyViewState previousState,
    required StudyViewState optimisticState,
    required int sessionId,
    required int sessionCardId,
    required int cardId,
    required int activeCount,
    required int virtualPage,
  }) async {
    try {
      await _sessionRepo.markCardOver(
        sessionId: sessionId,
        sessionCardId: sessionCardId,
      );
      await _cardRepo.incrementOverCount(cardId);

      if (activeCount <= 0) {
        await _sessionRepo.completeSession(sessionId);
        await _load();
        return;
      }

      await _sessionRepo.updateSessionIndex(
        sessionId,
        virtualPage % activeCount,
      );
    } catch (_) {
      final latest = state.valueOrNull;
      if (latest == optimisticState) {
        state = AsyncValue.data(previousState);
      }
    }
  }

  Future<void> clearSession() async {
    final current = state.valueOrNull;
    if (current == null || current.sessionData == null) {
      return;
    }
    await _sessionRepo.completeSession(current.sessionData!.session.id);
    await _load();
  }
}
