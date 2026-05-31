import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:eng_card/core/enums.dart';
import 'package:eng_card/data/local/app_database.dart';

class SessionCardView {
  const SessionCardView({
    required this.sessionCardId,
    required this.cardId,
    required this.title,
    required this.answer,
    required this.displayOrder,
    required this.isOver,
  });

  final int sessionCardId;
  final int cardId;
  final String title;
  final String? answer;
  final int displayOrder;
  final bool isOver;
}

class ActiveSessionData {
  const ActiveSessionData({
    required this.session,
    required this.cards,
  });

  final StudySession session;
  final List<SessionCardView> cards;

  List<SessionCardView> get activeCards => cards.where((card) => !card.isOver).toList()
    ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

  bool get isCompleted => activeCards.isEmpty;

  SessionCardView? currentCard() {
    final list = activeCards;
    if (list.isEmpty) {
      return null;
    }
    final index = session.currentIndex % list.length;
    return list[index];
  }
}

class SessionCreateResult {
  const SessionCreateResult({
    required this.sessionId,
    required this.selectedCardIds,
    required this.nextSequentialCursor,
  });

  final int sessionId;
  final List<int> selectedCardIds;
  final int nextSequentialCursor;
}

class StudySessionRepository {
  StudySessionRepository(this.db);

  final AppDatabase db;

  Future<StudySession?> findActiveSessionByDeck(int deckId) {
    return (db.select(db.studySessions)
          ..where((tbl) => tbl.deckId.equals(deckId) & tbl.completedAt.isNull())
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.startedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<ActiveSessionData?> loadActiveSessionByDeck(int deckId) async {
    final session = await findActiveSessionByDeck(deckId);
    if (session == null) {
      return null;
    }
    return loadSession(session.id);
  }

  Future<ActiveSessionData?> loadSession(int sessionId) async {
    final session = await (db.select(db.studySessions)..where((tbl) => tbl.id.equals(sessionId))).getSingleOrNull();
    if (session == null) {
      return null;
    }

    final rows = await (db.select(db.studySessionCards)
          ..where((tbl) => tbl.sessionId.equals(sessionId))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.displayOrder)]))
        .get();

    final cards = rows
        .map(
          (row) => SessionCardView(
            sessionCardId: row.id,
            cardId: row.cardId,
            title: row.titleSnapshot,
            answer: row.answerSnapshot,
            displayOrder: row.displayOrder,
            isOver: row.isOver,
          ),
        )
        .toList();

    return ActiveSessionData(session: session, cards: cards);
  }

  Future<SessionCreateResult> createSession({
    required int deckId,
    required List<CardItem> allCards,
    required SessionSource source,
    required int requestedCount,
    required int startSequentialCursor,
    required List<CardItem> weightedCards,
    required StudyMode mode,
  }) async {
    final cards = List<CardItem>.from(allCards)..sort((a, b) => a.sortIndex.compareTo(b.sortIndex));
    final total = cards.length;

    List<CardItem> selectedCards;
    var nextCursor = startSequentialCursor;

    if (requestedCount >= total) {
      selectedCards = cards;
      nextCursor = startSequentialCursor;
    } else {
      switch (source) {
        case SessionSource.manual:
          selectedCards = weightedCards;
        case SessionSource.weightedRandom:
          selectedCards = weightedCards;
        case SessionSource.sequential:
          selectedCards = _selectSequential(cards, requestedCount, startSequentialCursor);
          nextCursor = (startSequentialCursor + requestedCount) % total;
      }
    }

    final shuffled = List<CardItem>.from(selectedCards)..shuffle(Random());

    final sessionId = await db.transaction(() async {
      await (db.delete(db.studySessions)
            ..where((tbl) => tbl.deckId.equals(deckId) & tbl.completedAt.isNull()))
          .go();

      final id = await db.into(db.studySessions).insert(
            StudySessionsCompanion.insert(
              deckId: deckId,
              source: source.index,
              mode: mode.index,
            ),
          );

      await db.batch((batch) {
        for (var i = 0; i < shuffled.length; i++) {
          final card = shuffled[i];
          batch.insert(
            db.studySessionCards,
            StudySessionCardsCompanion.insert(
              sessionId: id,
              cardId: card.id,
              titleSnapshot: card.title,
              answerSnapshot: Value(card.answer),
              displayOrder: i,
            ),
          );
        }
      });

      await db.into(db.studyEvents).insert(
            StudyEventsCompanion.insert(
              sessionId: id,
              deckId: deckId,
              type: StudyEventType.sessionStarted.index,
              payload: Value(
                jsonEncode({
                  'source': source.name,
                  'count': shuffled.length,
                }),
              ),
            ),
          );

      return id;
    });

    return SessionCreateResult(
      sessionId: sessionId,
      selectedCardIds: shuffled.map((card) => card.id).toList(),
      nextSequentialCursor: nextCursor,
    );
  }

  Future<void> updateSessionIndex(int sessionId, int index) {
    return (db.update(db.studySessions)..where((tbl) => tbl.id.equals(sessionId))).write(
      StudySessionsCompanion(currentIndex: Value(index)),
    );
  }

  Future<void> markCardOver({
    required int sessionId,
    required int sessionCardId,
    required int deckId,
    required int cardId,
  }) async {
    final target = await (db.select(db.studySessionCards)..where((tbl) => tbl.id.equals(sessionCardId))).getSingle();
    if (target.isOver) {
      return;
    }

    await db.transaction(() async {
      await (db.update(db.studySessionCards)..where((tbl) => tbl.id.equals(sessionCardId))).write(
        const StudySessionCardsCompanion(isOver: Value(true)),
      );

      await db.into(db.studyEvents).insert(
            StudyEventsCompanion.insert(
              sessionId: sessionId,
              deckId: deckId,
              cardId: Value(cardId),
              type: StudyEventType.over.index,
            ),
          );
    });
  }

  Future<void> logReset({
    required int sessionId,
    required int deckId,
    required int cardId,
  }) {
    return db.into(db.studyEvents).insert(
          StudyEventsCompanion.insert(
            sessionId: sessionId,
            deckId: deckId,
            cardId: Value(cardId),
            type: StudyEventType.reset.index,
          ),
        );
  }

  Future<void> logReveal({
    required int sessionId,
    required int deckId,
    required int cardId,
  }) {
    return db.into(db.studyEvents).insert(
          StudyEventsCompanion.insert(
            sessionId: sessionId,
            deckId: deckId,
            cardId: Value(cardId),
            type: StudyEventType.answerRevealed.index,
          ),
        );
  }

  Future<void> completeSession(int sessionId, int deckId) async {
    await db.transaction(() async {
      await (db.update(db.studySessions)..where((tbl) => tbl.id.equals(sessionId))).write(
        StudySessionsCompanion(completedAt: Value(DateTime.now())),
      );

      await db.into(db.studyEvents).insert(
            StudyEventsCompanion.insert(
              sessionId: sessionId,
              deckId: deckId,
              type: StudyEventType.sessionCompleted.index,
            ),
          );
    });
  }

  Future<int> countActiveCards(int sessionId) async {
    final expr = db.studySessionCards.id.count();
    final query = db.selectOnly(db.studySessionCards)
      ..addColumns([expr])
      ..where(db.studySessionCards.sessionId.equals(sessionId) & db.studySessionCards.isOver.equals(false));
    final row = await query.getSingleOrNull();
    return row?.read(expr) ?? 0;
  }

  List<CardItem> _selectSequential(List<CardItem> cards, int count, int startCursor) {
    if (cards.isEmpty) {
      return [];
    }

    final selected = <CardItem>[];
    var cursor = startCursor % cards.length;
    final used = <int>{};

    while (selected.length < count && used.length < cards.length) {
      if (!used.contains(cursor)) {
        selected.add(cards[cursor]);
        used.add(cursor);
      }
      cursor = (cursor + 1) % cards.length;
    }

    return selected;
  }
}
