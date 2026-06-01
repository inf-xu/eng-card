import 'package:eng_card/app/providers.dart';
import 'package:eng_card/core/enums.dart';
import 'package:eng_card/data/local/app_database.dart';
import 'package:eng_card/data/repositories/card_repository.dart';
import 'package:eng_card/data/repositories/deck_repository.dart';
import 'package:eng_card/data/repositories/study_session_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudyViewState {
  const StudyViewState({
    required this.deckId,
    required this.mode,
    required this.sessionData,
    required this.virtualPage,
    required this.revealedCardIds,
  });

  final int deckId;
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
      deckId: deckId,
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

final studyControllerProvider = StateNotifierProvider.autoDispose
    .family<StudyController, AsyncValue<StudyViewState>, int>((ref, deckId) {
  return StudyController(ref, deckId);
});

class StudyController extends StateNotifier<AsyncValue<StudyViewState>> {
  StudyController(this.ref, this.deckId) : super(const AsyncValue.loading()) {
    _load();
  }

  final Ref ref;
  final int deckId;

  DeckRepository get _deckRepo => ref.read(deckRepositoryProvider);
  CardRepository get _cardRepo => ref.read(cardRepositoryProvider);
  StudySessionRepository get _sessionRepo => ref.read(sessionRepositoryProvider);

  Future<void> _load() async {
    final settings = ref.read(settingsControllerProvider).valueOrNull;
    final defaultMode = settings?.defaultStudyMode ?? StudyMode.practice;
    final active = await _sessionRepo.loadActiveSessionByDeck(deckId);
    final mode = active == null ? defaultMode : StudyMode.values[active.session.mode];
    state = AsyncValue.data(
      StudyViewState(
        deckId: deckId,
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
    final nextMode = current.mode == StudyMode.practice ? StudyMode.exam : StudyMode.practice;
    state = AsyncValue.data(current.copyWith(mode: nextMode));
  }

  Future<void> createSession({
    required SessionSource source,
    required int requestedCount,
    required List<int> manualCardIds,
  }) async {
    final prev = state.valueOrNull;
    final mode = prev?.mode ?? StudyMode.practice;
    state = const AsyncValue.loading();

    try {
      final cards = await _cardRepo.listCardsByDeck(deckId);
      if (cards.isEmpty) {
        state = AsyncValue.data(
          StudyViewState(
            deckId: deckId,
            mode: mode,
            sessionData: null,
            virtualPage: 1000,
            revealedCardIds: <int>{},
          ),
        );
        return;
      }

      List<CardItem> selectedBySource;
      final deck = await _deckRepo.getDeckById(deckId);
      final startCursor = deck?.nextSequentialCursor ?? 0;

      if (requestedCount >= cards.length) {
        selectedBySource = List<CardItem>.from(cards);
      } else {
        switch (source) {
          case SessionSource.manual:
            selectedBySource = cards.where((card) => manualCardIds.contains(card.id)).toList();
            if (selectedBySource.isEmpty) {
              selectedBySource = cards.take(requestedCount).toList();
            }
          case SessionSource.weightedRandom:
            selectedBySource = _cardRepo.weightedSampleWithoutReplacement(cards, requestedCount);
          case SessionSource.sequential:
            selectedBySource = cards;
        }
      }

      final result = await _sessionRepo.createSession(
        deckId: deckId,
        allCards: cards,
        source: source,
        requestedCount: requestedCount,
        startSequentialCursor: startCursor,
        weightedCards: selectedBySource,
        mode: mode,
      );

      await _cardRepo.incrementSelectionCounts(result.selectedCardIds);
      if (source == SessionSource.sequential && cards.isNotEmpty) {
        await _deckRepo.updateSequentialCursor(deckId, result.nextSequentialCursor);
      }

      final loaded = await _sessionRepo.loadSession(result.sessionId);
      state = AsyncValue.data(
        StudyViewState(
          deckId: deckId,
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
    await _sessionRepo.updateSessionIndex(current.sessionData!.session.id, normalized);
    // Exam mode: once user swipes to another card, the previously revealed answer
    // should be hidden again.
    final shouldClearRevealed = current.isExamMode && current.revealedCardIds.isNotEmpty;
    state = AsyncValue.data(
      current.copyWith(
        virtualPage: page,
        revealedCardIds: shouldClearRevealed ? <int>{} : current.revealedCardIds,
      ),
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

    final nextRevealed = Set<int>.from(current.revealedCardIds)..add(card.cardId);
    state = AsyncValue.data(current.copyWith(revealedCardIds: nextRevealed));

    await _sessionRepo.logReveal(
      sessionId: session.session.id,
      deckId: deckId,
      cardId: card.cardId,
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
      deckId: deckId,
      cardId: card.cardId,
    );
  }

  Future<void> overCurrentCard() async {
    final current = state.valueOrNull;
    final card = current?.currentCard;
    final session = current?.sessionData;
    if (current == null || card == null || session == null) {
      return;
    }

    await _sessionRepo.markCardOver(
      sessionId: session.session.id,
      sessionCardId: card.sessionCardId,
      deckId: deckId,
      cardId: card.cardId,
    );
    await _cardRepo.incrementOverCount(card.cardId);

    final activeCount = await _sessionRepo.countActiveCards(session.session.id);
    if (activeCount <= 0) {
      await _sessionRepo.completeSession(session.session.id, deckId);
      await _load();
      return;
    }

    final refreshed = await _sessionRepo.loadSession(session.session.id);
    state = AsyncValue.data(
      current.copyWith(
        sessionData: refreshed,
        revealedCardIds: Set<int>.from(current.revealedCardIds)..remove(card.cardId),
      ),
    );
  }

  Future<void> clearSession() async {
    final current = state.valueOrNull;
    if (current == null || current.sessionData == null) {
      return;
    }
    await _sessionRepo.completeSession(current.sessionData!.session.id, deckId);
    await _load();
  }
}
