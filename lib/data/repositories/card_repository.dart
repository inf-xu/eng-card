import 'package:drift/drift.dart';
import 'package:eng_card/data/local/app_database.dart';

class ActiveSessionCardLockedException implements Exception {
  const ActiveSessionCardLockedException(this.cardId);

  final int cardId;

  @override
  String toString() {
    return 'ActiveSessionCardLockedException: card $cardId is locked in active session';
  }
}

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

  Future<List<CardItem>> listCardsByDecks(List<int> deckIds) async {
    if (deckIds.isEmpty) {
      return [];
    }
    return (db.select(db.cardItems)
          ..where((tbl) => tbl.deckId.isIn(deckIds))
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.deckId),
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
  }) async {
    await _ensureCardNotLockedByActiveSession(id);
    await (db.update(db.cardItems)..where((tbl) => tbl.id.equals(id))).write(
      CardItemsCompanion(
        title: Value(title),
        answer: Value(answer),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> deleteCard(int id) async {
    await _ensureCardNotLockedByActiveSession(id);
    await (db.delete(db.cardItems)..where((tbl) => tbl.id.equals(id))).go();
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
    // Use `customUpdate` (not `customStatement`) so Drift can notify watchers
    // of `card_items` and keep stats/home in sync.
    return db.customUpdate(
      'UPDATE card_items SET reset_count = reset_count + 1 WHERE id = ?',
      variables: [Variable<int>(cardId)],
      updates: {db.cardItems},
    );
  }

  Future<void> incrementOverCount(int cardId) {
    return db.customUpdate(
      'UPDATE card_items SET over_count = over_count + 1 WHERE id = ?',
      variables: [Variable<int>(cardId)],
      updates: {db.cardItems},
    );
  }
  Future<void> _ensureCardNotLockedByActiveSession(int cardId) async {
    final rows = await db.customSelect(
      '''
      SELECT sc.card_id
      FROM study_session_cards sc
      INNER JOIN study_sessions s ON s.id = sc.session_id
      WHERE sc.card_id = ? AND s.completed_at IS NULL
      LIMIT 1
      ''',
      variables: [Variable<int>(cardId)],
      readsFrom: {db.studySessionCards, db.studySessions},
    ).get();
    if (rows.isNotEmpty) {
      throw ActiveSessionCardLockedException(cardId);
    }
  }
}
