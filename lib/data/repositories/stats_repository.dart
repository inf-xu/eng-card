import 'package:drift/drift.dart';
import 'package:eng_card/core/enums.dart';
import 'package:eng_card/data/local/app_database.dart';

class OverviewStats {
  const OverviewStats({
    required this.totalSessions,
    required this.completedSessions,
    required this.totalResets,
    required this.totalOvers,
    required this.totalReveals,
  });

  final int totalSessions;
  final int completedSessions;
  final int totalResets;
  final int totalOvers;
  final int totalReveals;

  double get completionRate {
    if (totalSessions == 0) {
      return 0;
    }
    return completedSessions / totalSessions;
  }
}

class DailyTrendPoint {
  const DailyTrendPoint({
    required this.day,
    required this.completions,
    required this.resets,
  });

  final DateTime day;
  final int completions;
  final int resets;
}

class DeckRankItem {
  const DeckRankItem({required this.deckName, required this.completedSessions});

  final String deckName;
  final int completedSessions;
}

class DifficultCardItem {
  const DifficultCardItem({
    required this.title,
    required this.resetCount,
    required this.overCount,
  });

  final String title;
  final int resetCount;
  final int overCount;
}

class StatsRepository {
  StatsRepository(this.db);

  final AppDatabase db;

  Stream<OverviewStats> watchOverview() {
    return _watchTables([
      TableUpdateQuery.onTable(db.studySessions),
      TableUpdateQuery.onTable(db.studyEvents),
    ], loadOverview);
  }

  Future<OverviewStats> loadOverview() async {
    final sessionCountExpr = db.studySessions.id.count();
    final completedCountExpr = db.studySessions.completedAt.count();
    final sessionRow = await (db.selectOnly(
      db.studySessions,
    )..addColumns([sessionCountExpr, completedCountExpr])).getSingleOrNull();

    final eventCountExpr = db.studyEvents.id.count();

    Future<int> countByEvent(StudyEventType type) async {
      final row =
          await (db.selectOnly(db.studyEvents)
                ..addColumns([eventCountExpr])
                ..where(db.studyEvents.type.equals(type.index)))
              .getSingleOrNull();
      return row?.read(eventCountExpr) ?? 0;
    }

    return OverviewStats(
      totalSessions: sessionRow?.read(sessionCountExpr) ?? 0,
      completedSessions: sessionRow?.read(completedCountExpr) ?? 0,
      totalResets: await countByEvent(StudyEventType.reset),
      totalOvers: await countByEvent(StudyEventType.over),
      totalReveals: await countByEvent(StudyEventType.answerRevealed),
    );
  }

  Stream<List<DailyTrendPoint>> watchTrend({int days = 30}) {
    return _watchTables([
      TableUpdateQuery.onTable(db.studyEvents),
    ], () => loadTrend(days: days));
  }

  Future<List<DailyTrendPoint>> loadTrend({int days = 30}) async {
    final since = DateTime.now().subtract(Duration(days: days - 1));
    final events = await (db.select(
      db.studyEvents,
    )..where((tbl) => tbl.occurredAt.isBiggerOrEqualValue(since))).get();

    final dayMap = <String, ({DateTime day, int completions, int resets})>{};
    for (final event in events) {
      final day = DateTime(
        event.occurredAt.year,
        event.occurredAt.month,
        event.occurredAt.day,
      );
      final key = day.toIso8601String();
      final current = dayMap[key] ?? (day: day, completions: 0, resets: 0);
      if (event.type == StudyEventType.sessionCompleted.index) {
        dayMap[key] = (
          day: day,
          completions: current.completions + 1,
          resets: current.resets,
        );
      } else if (event.type == StudyEventType.reset.index) {
        dayMap[key] = (
          day: day,
          completions: current.completions,
          resets: current.resets + 1,
        );
      }
    }

    final result = <DailyTrendPoint>[];
    for (var i = 0; i < days; i++) {
      final day = DateTime.now().subtract(Duration(days: days - i - 1));
      final key = DateTime(day.year, day.month, day.day).toIso8601String();
      final data = dayMap[key];
      result.add(
        DailyTrendPoint(
          day: DateTime(day.year, day.month, day.day),
          completions: data?.completions ?? 0,
          resets: data?.resets ?? 0,
        ),
      );
    }

    return result;
  }

  Stream<List<DeckRankItem>> watchDeckRanking({int limit = 5}) {
    return _watchTables([
      TableUpdateQuery.onTable(db.studyEvents),
      TableUpdateQuery.onTable(db.decks),
    ], () => loadDeckRanking(limit: limit));
  }

  Future<List<DeckRankItem>> loadDeckRanking({int limit = 5}) async {
    final sql = '''
      SELECT d.name AS deck_name, COUNT(e.id) AS completed_sessions
      FROM study_events e
      JOIN decks d ON d.id = e.deck_id
      WHERE e.type = ?
      GROUP BY e.deck_id
      ORDER BY completed_sessions DESC
      LIMIT ?
    ''';

    final rows = await db
        .customSelect(
          sql,
          variables: [
            Variable(StudyEventType.sessionCompleted.index),
            Variable(limit),
          ],
        )
        .get();

    return rows
        .map(
          (row) => DeckRankItem(
            deckName: row.read<String>('deck_name'),
            completedSessions: row.read<int>('completed_sessions'),
          ),
        )
        .toList();
  }

  Stream<List<DifficultCardItem>> watchDifficultCards({int limit = 5}) {
    return _watchTables([
      TableUpdateQuery.onTable(db.cardItems),
    ], () => loadDifficultCards(limit: limit));
  }

  Future<List<DifficultCardItem>> loadDifficultCards({int limit = 5}) async {
    final rows =
        await (db.select(db.cardItems)
              ..orderBy([
                (tbl) => OrderingTerm.desc(tbl.resetCount),
                (tbl) => OrderingTerm.asc(tbl.overCount),
              ])
              ..limit(limit))
            .get();

    return rows
        .map(
          (row) => DifficultCardItem(
            title: row.title,
            resetCount: row.resetCount,
            overCount: row.overCount,
          ),
        )
        .toList();
  }

  Stream<Map<DateTime, int>> watchCalendarHeat() {
    return _watchTables([
      TableUpdateQuery.onTable(db.studyEvents),
    ], loadCalendarHeat);
  }

  Future<Map<DateTime, int>> loadCalendarHeat() async {
    final events = await db.select(db.studyEvents).get();
    final map = <DateTime, int>{};
    for (final event in events) {
      final day = DateTime(
        event.occurredAt.year,
        event.occurredAt.month,
        event.occurredAt.day,
      );
      map[day] = (map[day] ?? 0) + 1;
    }
    return map;
  }

  Stream<int> watchCurrentStreakDays() {
    return watchCalendarHeat().map(_computeStreakDays);
  }

  Future<int> currentStreakDays() async {
    final map = await loadCalendarHeat();
    return _computeStreakDays(map);
  }

  int _computeStreakDays(Map<DateTime, int> map) {
    if (map.isEmpty) {
      return 0;
    }

    var streak = 0;
    var cursor = DateTime.now();
    while (true) {
      final day = DateTime(cursor.year, cursor.month, cursor.day);
      if ((map[day] ?? 0) <= 0) {
        break;
      }
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  Stream<T> _watchTables<T>(
    List<TableUpdateQuery> queries,
    Future<T> Function() loader,
  ) async* {
    yield await loader();
    final updates = db.tableUpdates(TableUpdateQuery.allOf(queries));
    await for (final _ in updates) {
      yield await loader();
    }
  }
}
