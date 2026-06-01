import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:eng_card/data/local/app_database.dart';
import 'package:eng_card/data/repositories/card_repository.dart';
import 'package:eng_card/data/repositories/study_session_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StudySessionRepository weighted sample', () {
    test('returns all cards when requested count >= total', () {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final repo = StudySessionRepository(db);
      final cards = [
        CardItem(
          id: 1,
          deckId: 1,
          title: 'a',
          answer: null,
          sortIndex: 0,
          selectionCount: 0,
          resetCount: 0,
          overCount: 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        CardItem(
          id: 2,
          deckId: 1,
          title: 'b',
          answer: null,
          sortIndex: 1,
          selectionCount: 1,
          resetCount: 1,
          overCount: 1,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      final selected = repo.weightedSampleWithoutReplacementForTesting(
        cards,
        3,
      );

      expect(selected.length, 2);
      expect(selected.map((item) => item.id).toSet(), {1, 2});
      db.close();
    });

    test('returns unique cards without replacement', () {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final repo = StudySessionRepository(db);
      final now = DateTime.now();
      final cards = List.generate(
        20,
        (index) => CardItem(
          id: index + 1,
          deckId: 1,
          title: 'c$index',
          answer: null,
          sortIndex: index,
          selectionCount: index % 3,
          resetCount: index % 4,
          overCount: index % 2,
          createdAt: now,
          updatedAt: now,
        ),
      );

      final selected = repo.weightedSampleWithoutReplacementForTesting(
        cards,
        10,
      );

      expect(selected.length, 10);
      expect(selected.map((item) => item.id).toSet().length, 10);
      db.close();
    });
  });

  group('CardRepository active session lock', () {
    late AppDatabase db;
    late CardRepository repo;

    setUp(() {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      repo = CardRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('blocks update and delete for cards in active session', () async {
      final now = DateTime.now();
      final deckId = await db
          .into(db.decks)
          .insert(
            DecksCompanion.insert(
              name: 'deck',
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );
      final cardId = await db
          .into(db.cardItems)
          .insert(
            CardItemsCompanion.insert(
              deckId: deckId,
              title: 'locked',
              answer: const Value('ans'),
              sortIndex: 0,
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );
      final sessionId = await db
          .into(db.studySessions)
          .insert(
            StudySessionsCompanion.insert(
              source: 0,
              mode: 0,
              currentIndex: const Value(0),
              startedAt: Value(now),
            ),
          );
      await db
          .into(db.studySessionDecks)
          .insert(
            StudySessionDecksCompanion.insert(
              sessionId: sessionId,
              deckId: deckId,
              deckOrder: 0,
              requestedCountSnapshot: 1,
            ),
          );
      await db
          .into(db.studySessionCards)
          .insert(
            StudySessionCardsCompanion.insert(
              sessionId: sessionId,
              cardId: cardId,
              sourceDeckId: deckId,
              titleSnapshot: 'locked',
              answerSnapshot: const Value('ans'),
              displayOrder: 0,
              isOver: const Value(false),
            ),
          );

      await expectLater(
        repo.updateCard(id: cardId, title: 'new', answer: 'new'),
        throwsA(isA<ActiveSessionCardLockedException>()),
      );
      await expectLater(
        repo.deleteCard(cardId),
        throwsA(isA<ActiveSessionCardLockedException>()),
      );
    });

    test('allows update and delete for cards outside active session', () async {
      final now = DateTime.now();
      final deckId = await db
          .into(db.decks)
          .insert(
            DecksCompanion.insert(
              name: 'deck',
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );
      final cardId = await db
          .into(db.cardItems)
          .insert(
            CardItemsCompanion.insert(
              deckId: deckId,
              title: 'editable',
              answer: const Value('ans'),
              sortIndex: 0,
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );

      await repo.updateCard(id: cardId, title: 'edited', answer: 'x');
      final updated = await (db.select(
        db.cardItems,
      )..where((t) => t.id.equals(cardId))).getSingle();
      expect(updated.title, 'edited');

      await repo.deleteCard(cardId);
      final row = await (db.select(
        db.cardItems,
      )..where((t) => t.id.equals(cardId))).getSingleOrNull();
      expect(row == null, isTrue);
    });
  });

  group('CardRepository deck filters', () {
    late AppDatabase db;
    late CardRepository repo;

    setUp(() {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      repo = CardRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('lists cards from multiple decks in stable order', () async {
      final now = DateTime.now();
      final firstDeckId = await db
          .into(db.decks)
          .insert(
            DecksCompanion.insert(
              name: 'first',
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );
      final secondDeckId = await db
          .into(db.decks)
          .insert(
            DecksCompanion.insert(
              name: 'second',
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );
      final thirdDeckId = await db
          .into(db.decks)
          .insert(
            DecksCompanion.insert(
              name: 'third',
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );
      await db
          .into(db.cardItems)
          .insert(
            CardItemsCompanion.insert(
              deckId: secondDeckId,
              title: 'second-2',
              answer: const Value(null),
              sortIndex: 1,
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );
      await db
          .into(db.cardItems)
          .insert(
            CardItemsCompanion.insert(
              deckId: firstDeckId,
              title: 'first-1',
              answer: const Value(null),
              sortIndex: 0,
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );
      await db
          .into(db.cardItems)
          .insert(
            CardItemsCompanion.insert(
              deckId: secondDeckId,
              title: 'second-1',
              answer: const Value(null),
              sortIndex: 0,
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );
      await db
          .into(db.cardItems)
          .insert(
            CardItemsCompanion.insert(
              deckId: thirdDeckId,
              title: 'third-1',
              answer: const Value(null),
              sortIndex: 0,
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );

      final cards = await repo.listCardsByDecks([secondDeckId, firstDeckId]);

      expect(cards.map((card) => card.title), [
        'first-1',
        'second-1',
        'second-2',
      ]);
    });
  });
}
