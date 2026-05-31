import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:eng_card/data/local/app_database.dart';
import 'package:flutter/services.dart';

class BootstrapRepository {
  BootstrapRepository(this.db);

  final AppDatabase db;

  Future<int?> seedIpaDeckFromAsset({String assetPath = 'doc/ipa.json'}) async {
    final payload = await _loadSeedPayload(assetPath);
    if (payload.cards.isEmpty || payload.deckName.isEmpty) {
      return null;
    }

    return db.transaction(() async {
      final deck =
          await (db.select(db.decks)
                ..where((tbl) => tbl.name.equals(payload.deckName))
                ..orderBy([(tbl) => OrderingTerm.asc(tbl.createdAt)])
                ..limit(1))
              .getSingleOrNull();

      final now = DateTime.now();
      final deckId =
          deck?.id ??
          await db
              .into(db.decks)
              .insert(
                DecksCompanion.insert(
                  name: payload.deckName,
                  createdAt: Value(now),
                  updatedAt: Value(now),
                ),
              );

      final existingCards =
          await (db.select(db.cardItems)
                ..where((tbl) => tbl.deckId.equals(deckId))
                ..orderBy([(tbl) => OrderingTerm.asc(tbl.sortIndex)]))
              .get();

      final existingKeys = existingCards
          .map((card) => _cardKey(card.title, card.answer))
          .toSet();
      var nextSort = existingCards.isEmpty
          ? 0
          : existingCards.last.sortIndex + 1;

      for (final card in payload.cards) {
        final key = _cardKey(card.title, card.answer);
        if (existingKeys.contains(key)) {
          continue;
        }
        await db
            .into(db.cardItems)
            .insert(
              CardItemsCompanion.insert(
                deckId: deckId,
                title: card.title,
                answer: Value(card.answer),
                sortIndex: nextSort,
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
            );
        existingKeys.add(key);
        nextSort++;
      }

      return deckId;
    });
  }

  Future<_IpaSeedPayload> _loadSeedPayload(String assetPath) async {
    final raw = await rootBundle.loadString(assetPath);
    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      return const _IpaSeedPayload(deckName: '', cards: []);
    }

    final deckName = (decoded['deck'] as String? ?? '').trim();
    final cardsRaw = decoded['cards'];
    if (cardsRaw is! List) {
      return _IpaSeedPayload(deckName: deckName, cards: const []);
    }

    final cards = <_IpaSeedCard>[];
    for (final item in cardsRaw) {
      if (item is! Map<String, dynamic>) {
        continue;
      }
      final title = (item['title'] as String? ?? '').trim();
      if (title.isEmpty) {
        continue;
      }
      final answerRaw = (item['answer'] as String?)?.trim();
      final answer = (answerRaw == null || answerRaw.isEmpty)
          ? null
          : answerRaw;
      cards.add(_IpaSeedCard(title: title, answer: answer));
    }

    return _IpaSeedPayload(deckName: deckName, cards: cards);
  }

  String _cardKey(String title, String? answer) {
    final normalizedAnswer = (answer ?? '').trim();
    return '${title.trim()}||$normalizedAnswer';
  }
}

class _IpaSeedPayload {
  const _IpaSeedPayload({required this.deckName, required this.cards});

  final String deckName;
  final List<_IpaSeedCard> cards;
}

class _IpaSeedCard {
  const _IpaSeedCard({required this.title, required this.answer});

  final String title;
  final String? answer;
}
