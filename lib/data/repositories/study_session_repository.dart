import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:eng_card/core/enums.dart';
import 'package:eng_card/data/local/app_database.dart';

class SessionCardView {
  const SessionCardView({
    required this.sessionCardId,
    required this.cardId,
    required this.sourceDeckId,
    required this.title,
    required this.answer,
    required this.displayOrder,
    required this.isOver,
  });

  final int sessionCardId;
  final int cardId;
  final int sourceDeckId;
  final String title;
  final String? answer;
  final int displayOrder;
  final bool isOver;
}

class ActiveSessionData {
  const ActiveSessionData({
    required this.session,
    required this.sourceDeckIds,
    required this.cards,
  });

  final StudySession session;
  final List<int> sourceDeckIds;
  final List<SessionCardView> cards;

  List<SessionCardView> get activeCards =>
      cards.where((card) => !card.isOver).toList()
        ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

  bool get isCompleted => activeCards.isEmpty;
}

class SessionCreateRequest {
  const SessionCreateRequest({
    required this.sourceDeckIds,
    required this.source,
    required this.requestedCount,
    required this.manualCardIds,
    required this.mode,
  });

  final List<int> sourceDeckIds;
  final SessionSource source;
  final int requestedCount;
  final List<int> manualCardIds;
  final StudyMode mode;
}

class SessionCreateResult {
  const SessionCreateResult({
    required this.sessionId,
    required this.selectedCardIds,
    required this.nextSequentialCursors,
  });

  final int sessionId;
  final List<int> selectedCardIds;
  final Map<int, int> nextSequentialCursors;
}

class StudySessionRepository {
  StudySessionRepository(this.db);

  final AppDatabase db;

  Future<StudySession?> findActiveSession() {
    return (db.select(db.studySessions)
          ..where((tbl) => tbl.completedAt.isNull())
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.startedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<ActiveSessionData?> loadActiveSession() async {
    final session = await findActiveSession();
    if (session == null) {
      return null;
    }
    return loadSession(session.id);
  }

  Future<ActiveSessionData?> loadSession(int sessionId) async {
    final session = await (db.select(
      db.studySessions,
    )..where((tbl) => tbl.id.equals(sessionId))).getSingleOrNull();
    if (session == null) {
      return null;
    }

    final deckRows =
        await (db.select(db.studySessionDecks)
              ..where((tbl) => tbl.sessionId.equals(sessionId))
              ..orderBy([(tbl) => OrderingTerm.asc(tbl.deckOrder)]))
            .get();
    final sourceDeckIds = deckRows.map((row) => row.deckId).toList();

    final rows =
        await (db.select(db.studySessionCards)
              ..where((tbl) => tbl.sessionId.equals(sessionId))
              ..orderBy([(tbl) => OrderingTerm.asc(tbl.displayOrder)]))
            .get();
    final cards = rows
        .map(
          (row) => SessionCardView(
            sessionCardId: row.id,
            cardId: row.cardId,
            sourceDeckId: row.sourceDeckId,
            title: row.titleSnapshot,
            answer: row.answerSnapshot,
            displayOrder: row.displayOrder,
            isOver: row.isOver,
          ),
        )
        .toList();

    return ActiveSessionData(
      session: session,
      sourceDeckIds: sourceDeckIds,
      cards: cards,
    );
  }

  Future<SessionCreateResult> createSession(
    SessionCreateRequest request,
  ) async {
    final sourceDeckIds = request.sourceDeckIds.toSet().toList();
    if (sourceDeckIds.isEmpty) {
      return const SessionCreateResult(
        sessionId: -1,
        selectedCardIds: [],
        nextSequentialCursors: {},
      );
    }

    final cards = await _loadCardsBySourceDecks(sourceDeckIds);
    if (cards.isEmpty) {
      return const SessionCreateResult(
        sessionId: -1,
        selectedCardIds: [],
        nextSequentialCursors: {},
      );
    }

    final selection = await _selectCards(
      cards: cards,
      request: request,
      sourceDeckIds: sourceDeckIds,
    );
    final selectedCards = selection.cards;

    final sessionId = await db.transaction(() async {
      await (db.update(db.studySessions)
            ..where((tbl) => tbl.completedAt.isNull()))
          .write(StudySessionsCompanion(completedAt: Value(DateTime.now())));

      final id = await db
          .into(db.studySessions)
          .insert(
            StudySessionsCompanion.insert(
              source: request.source.index,
              mode: request.mode.index,
            ),
          );

      await db.batch((batch) {
        for (var i = 0; i < sourceDeckIds.length; i++) {
          batch.insert(
            db.studySessionDecks,
            StudySessionDecksCompanion.insert(
              sessionId: id,
              deckId: sourceDeckIds[i],
              deckOrder: i,
              requestedCountSnapshot: request.requestedCount,
            ),
          );
        }

        for (var i = 0; i < selectedCards.length; i++) {
          final card = selectedCards[i];
          batch.insert(
            db.studySessionCards,
            StudySessionCardsCompanion.insert(
              sessionId: id,
              cardId: card.id,
              sourceDeckId: card.deckId,
              titleSnapshot: card.title,
              answerSnapshot: Value(card.answer),
              displayOrder: i,
            ),
          );
        }
      });

      await db
          .into(db.studyEvents)
          .insert(
            StudyEventsCompanion.insert(
              sessionId: id,
              type: StudyEventType.sessionStarted.index,
              payload: Value(
                jsonEncode({
                  'source': request.source.name,
                  'count': selectedCards.length,
                  'deckIds': sourceDeckIds,
                }),
              ),
            ),
          );

      return id;
    });

    return SessionCreateResult(
      sessionId: sessionId,
      selectedCardIds: selectedCards.map((card) => card.id).toList(),
      nextSequentialCursors: selection.nextSequentialCursors,
    );
  }

  Future<void> updateSessionIndex(int sessionId, int index) {
    return (db.update(db.studySessions)
          ..where((tbl) => tbl.id.equals(sessionId)))
        .write(StudySessionsCompanion(currentIndex: Value(index)));
  }

  Future<void> markCardOver({
    required int sessionId,
    required int sessionCardId,
  }) async {
    final target = await (db.select(
      db.studySessionCards,
    )..where((tbl) => tbl.id.equals(sessionCardId))).getSingle();
    if (target.isOver) {
      return;
    }

    await db.transaction(() async {
      await (db.update(db.studySessionCards)
            ..where((tbl) => tbl.id.equals(sessionCardId)))
          .write(const StudySessionCardsCompanion(isOver: Value(true)));

      await db
          .into(db.studyEvents)
          .insert(
            StudyEventsCompanion.insert(
              sessionId: sessionId,
              sessionCardId: Value(sessionCardId),
              sourceDeckId: Value(target.sourceDeckId),
              cardId: Value(target.cardId),
              type: StudyEventType.over.index,
            ),
          );
    });
  }

  Future<void> logReset({
    required int sessionId,
    required int sessionCardId,
  }) async {
    final target = await (db.select(
      db.studySessionCards,
    )..where((tbl) => tbl.id.equals(sessionCardId))).getSingle();
    await db
        .into(db.studyEvents)
        .insert(
          StudyEventsCompanion.insert(
            sessionId: sessionId,
            sessionCardId: Value(sessionCardId),
            sourceDeckId: Value(target.sourceDeckId),
            cardId: Value(target.cardId),
            type: StudyEventType.reset.index,
          ),
        );
  }

  Future<void> logReveal({
    required int sessionId,
    required int sessionCardId,
  }) async {
    final target = await (db.select(
      db.studySessionCards,
    )..where((tbl) => tbl.id.equals(sessionCardId))).getSingle();
    await db
        .into(db.studyEvents)
        .insert(
          StudyEventsCompanion.insert(
            sessionId: sessionId,
            sessionCardId: Value(sessionCardId),
            sourceDeckId: Value(target.sourceDeckId),
            cardId: Value(target.cardId),
            type: StudyEventType.answerRevealed.index,
          ),
        );
  }

  Future<void> completeSession(int sessionId) async {
    await db.transaction(() async {
      await (db.update(db.studySessions)
            ..where((tbl) => tbl.id.equals(sessionId)))
          .write(StudySessionsCompanion(completedAt: Value(DateTime.now())));

      await db
          .into(db.studyEvents)
          .insert(
            StudyEventsCompanion.insert(
              sessionId: sessionId,
              type: StudyEventType.sessionCompleted.index,
            ),
          );
    });
  }

  Future<int> countActiveCards(int sessionId) async {
    final expr = db.studySessionCards.id.count();
    final query = db.selectOnly(db.studySessionCards)
      ..addColumns([expr])
      ..where(
        db.studySessionCards.sessionId.equals(sessionId) &
            db.studySessionCards.isOver.equals(false),
      );
    final row = await query.getSingleOrNull();
    return row?.read(expr) ?? 0;
  }

  Future<List<CardItem>> _loadCardsBySourceDecks(
    List<int> sourceDeckIds,
  ) async {
    final cards = await (db.select(
      db.cardItems,
    )..where((tbl) => tbl.deckId.isIn(sourceDeckIds))).get();
    final deckOrder = {
      for (var index = 0; index < sourceDeckIds.length; index++)
        sourceDeckIds[index]: index,
    };
    cards.sort((a, b) {
      final deckCompare = (deckOrder[a.deckId] ?? 0).compareTo(
        deckOrder[b.deckId] ?? 0,
      );
      if (deckCompare != 0) {
        return deckCompare;
      }
      return a.sortIndex.compareTo(b.sortIndex);
    });
    return cards;
  }

  Future<_CardSelection> _selectCards({
    required List<CardItem> cards,
    required SessionCreateRequest request,
    required List<int> sourceDeckIds,
  }) async {
    final requestedCount = request.requestedCount.clamp(1, cards.length);
    switch (request.source) {
      case SessionSource.manual:
        final manualCards = cards
            .where((card) => request.manualCardIds.contains(card.id))
            .toList();
        return _CardSelection(
          cards: manualCards.isEmpty
              ? cards.take(requestedCount).toList()
              : manualCards.take(requestedCount).toList(),
          nextSequentialCursors: const {},
        );
      case SessionSource.weightedRandom:
        return _CardSelection(
          cards: _weightedSampleWithoutReplacement(cards, requestedCount),
          nextSequentialCursors: const {},
        );
      case SessionSource.sequential:
        return _selectSequentialAcrossDecks(
          cards: cards,
          count: requestedCount,
          sourceDeckIds: sourceDeckIds,
        );
    }
  }

  Future<_CardSelection> _selectSequentialAcrossDecks({
    required List<CardItem> cards,
    required int count,
    required List<int> sourceDeckIds,
  }) async {
    final byDeck = <int, List<CardItem>>{};
    for (final deckId in sourceDeckIds) {
      byDeck[deckId] = cards.where((card) => card.deckId == deckId).toList()
        ..sort((a, b) => a.sortIndex.compareTo(b.sortIndex));
    }

    final decks = await (db.select(
      db.decks,
    )..where((tbl) => tbl.id.isIn(sourceDeckIds))).get();
    final cursorByDeck = {
      for (final deck in decks) deck.id: deck.nextSequentialCursor,
    };
    final selected = <CardItem>[];
    final nextCursors = <int, int>{};

    var deckCursor = 0;
    while (selected.length < count &&
        byDeck.values.any((items) => items.isNotEmpty)) {
      final deckId = sourceDeckIds[deckCursor % sourceDeckIds.length];
      final deckCards = byDeck[deckId] ?? const <CardItem>[];
      if (deckCards.isNotEmpty) {
        final cursor = cursorByDeck[deckId] ?? 0;
        final index = cursor % deckCards.length;
        selected.add(deckCards[index]);
        cursorByDeck[deckId] = cursor + 1;
        nextCursors[deckId] = (cursor + 1) % deckCards.length;
        byDeck[deckId] = List<CardItem>.from(deckCards)..removeAt(index);
      }
      deckCursor++;
    }

    return _CardSelection(cards: selected, nextSequentialCursors: nextCursors);
  }

  List<CardItem> _weightedSampleWithoutReplacement(
    List<CardItem> cards,
    int count,
  ) {
    if (count >= cards.length) {
      return List<CardItem>.from(cards);
    }

    final random = Random();
    final pool = List<CardItem>.from(cards);
    final selected = <CardItem>[];

    while (selected.length < count && pool.isNotEmpty) {
      final totalWeight = pool.fold<double>(
        0,
        (sum, card) => sum + _weight(card),
      );
      var threshold = random.nextDouble() * totalWeight;
      var pickedIndex = 0;
      for (var i = 0; i < pool.length; i++) {
        threshold -= _weight(pool[i]);
        if (threshold <= 0) {
          pickedIndex = i;
          break;
        }
      }
      selected.add(pool.removeAt(pickedIndex));
    }

    return selected;
  }

  List<CardItem> weightedSampleWithoutReplacementForTesting(
    List<CardItem> cards,
    int count,
  ) {
    return _weightedSampleWithoutReplacement(cards, count);
  }

  double _weight(CardItem card) {
    final numerator = (card.resetCount + 1) * (card.resetCount + 1);
    final denominator = (card.selectionCount + 1) * (card.overCount + 1);
    final raw = numerator / denominator;
    return raw.clamp(0.2, 20).toDouble();
  }
}

class _CardSelection {
  const _CardSelection({
    required this.cards,
    required this.nextSequentialCursors,
  });

  final List<CardItem> cards;
  final Map<int, int> nextSequentialCursors;
}
