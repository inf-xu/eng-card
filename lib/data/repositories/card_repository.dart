import 'dart:math';

import 'package:drift/drift.dart';
import 'package:eng_card/data/local/app_database.dart';

class CardRepository {
  CardRepository(this.db);

  final AppDatabase db;

  Stream<List<CardItem>> watchCardsByDeck(int deckId) {
    return (db.select(db.cardItems)
          ..where((tbl) => tbl.deckId.equals(deckId))
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.sortIndex),
          ]))
        .watch();
  }

  Future<List<CardItem>> listCardsByDeck(int deckId) {
    return (db.select(db.cardItems)
          ..where((tbl) => tbl.deckId.equals(deckId))
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.sortIndex),
          ]))
        .get();
  }

  Future<int> createCard({
    required int deckId,
    required String title,
    String? answer,
  }) async {
    final maxSortExpr = db.cardItems.sortIndex.max();
    final maxSortQuery = db.selectOnly(db.cardItems)
      ..addColumns([maxSortExpr])
      ..where(db.cardItems.deckId.equals(deckId));
    final row = await maxSortQuery.getSingleOrNull();
    final nextSort = (row?.read(maxSortExpr) ?? -1) + 1;
    final now = DateTime.now();

    return db.into(db.cardItems).insert(
          CardItemsCompanion.insert(
            deckId: deckId,
            title: title,
            answer: Value(answer),
            sortIndex: nextSort,
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
  }

  Future<void> updateCard({
    required int id,
    required String title,
    String? answer,
  }) {
    return (db.update(db.cardItems)..where((tbl) => tbl.id.equals(id))).write(
      CardItemsCompanion(
        title: Value(title),
        answer: Value(answer),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> deleteCard(int id) {
    return (db.delete(db.cardItems)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<void> incrementSelectionCounts(List<int> cardIds) async {
    if (cardIds.isEmpty) {
      return;
    }
    await db.batch((batch) {
      for (final id in cardIds) {
        batch.customStatement(
          'UPDATE card_items SET selection_count = selection_count + 1 WHERE id = ?',
          [id],
        );
      }
    });
  }

  Future<void> incrementResetCount(int cardId) {
    return db.customStatement(
      'UPDATE card_items SET reset_count = reset_count + 1 WHERE id = ?',
      [cardId],
    );
  }

  Future<void> incrementOverCount(int cardId) {
    return db.customStatement(
      'UPDATE card_items SET over_count = over_count + 1 WHERE id = ?',
      [cardId],
    );
  }

  List<CardItem> weightedSampleWithoutReplacement(List<CardItem> cards, int count) {
    if (count >= cards.length) {
      return List<CardItem>.from(cards);
    }

    final random = Random();
    final pool = List<CardItem>.from(cards);
    final selected = <CardItem>[];

    while (selected.length < count && pool.isNotEmpty) {
      final totalWeight = pool.fold<double>(0, (sum, card) => sum + _weight(card));
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

  double _weight(CardItem card) {
    final numerator = (card.resetCount + 1) * (card.resetCount + 1);
    final denominator = (card.selectionCount + 1) * (card.overCount + 1);
    final raw = numerator / denominator;
    return raw.clamp(0.2, 20).toDouble();
  }
}
