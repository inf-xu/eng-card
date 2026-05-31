import 'package:eng_card/data/local/app_database.dart';
import 'package:eng_card/data/repositories/card_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CardRepository weighted sample', () {
    test('returns all cards when requested count >= total', () {
      final repo = CardRepository(AppDatabase.forTesting(NativeDatabase.memory()));
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

      final selected = repo.weightedSampleWithoutReplacement(cards, 3);
      expect(selected.length, 2);
      expect(selected.map((item) => item.id).toSet(), {1, 2});
      repo.db.close();
    });

    test('returns unique cards without replacement', () {
      final repo = CardRepository(AppDatabase.forTesting(NativeDatabase.memory()));
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

      final selected = repo.weightedSampleWithoutReplacement(cards, 10);
      expect(selected.length, 10);
      expect(selected.map((item) => item.id).toSet().length, 10);
      repo.db.close();
    });
  });
}
