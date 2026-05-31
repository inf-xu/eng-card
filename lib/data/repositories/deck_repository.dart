import 'package:drift/drift.dart';
import 'package:eng_card/data/local/app_database.dart';

class DeckWithCount {
  const DeckWithCount({
    required this.deck,
    required this.cardCount,
  });

  final Deck deck;
  final int cardCount;
}

class DeckRepository {
  DeckRepository(this.db);

  final AppDatabase db;

  Stream<List<DeckWithCount>> watchDecks() {
    final query = db.select(db.decks).join([
      leftOuterJoin(
        db.cardItems,
        db.cardItems.deckId.equalsExp(db.decks.id),
      ),
    ])
      ..groupBy([db.decks.id])
      ..orderBy([OrderingTerm.asc(db.decks.createdAt)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        final deck = row.readTable(db.decks);
        final countExpr = db.cardItems.id.count();
        final count = row.read(countExpr) ?? 0;
        return DeckWithCount(deck: deck, cardCount: count);
      }).toList();
    });
  }

  Future<int> createDeck(String name) {
    final now = DateTime.now();
    return db.into(db.decks).insert(
          DecksCompanion.insert(
            name: name,
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
  }

  Future<void> updateDeck(int id, String name) {
    return (db.update(db.decks)..where((tbl) => tbl.id.equals(id))).write(
      DecksCompanion(
        name: Value(name),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> deleteDeck(int id) {
    return (db.delete(db.decks)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<Deck?> getDeckById(int id) {
    return (db.select(db.decks)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<void> updateSequentialCursor(int deckId, int nextCursor) {
    return (db.update(db.decks)..where((tbl) => tbl.id.equals(deckId))).write(
      DecksCompanion(
        nextSequentialCursor: Value(nextCursor),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
