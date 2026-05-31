import 'package:eng_card/app/providers.dart';
import 'package:eng_card/data/repositories/stats_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final overviewStatsProvider = StreamProvider<OverviewStats>((ref) {
  return ref.watch(statsRepositoryProvider).watchOverview();
});

final trendStatsProvider = StreamProvider<List<DailyTrendPoint>>((ref) {
  return ref.watch(statsRepositoryProvider).watchTrend(days: 30);
});

final deckRankingProvider = StreamProvider<List<DeckRankItem>>((ref) {
  return ref.watch(statsRepositoryProvider).watchDeckRanking(limit: 5);
});

final difficultCardsProvider = StreamProvider<List<DifficultCardItem>>((ref) {
  return ref.watch(statsRepositoryProvider).watchDifficultCards(limit: 5);
});

final calendarHeatProvider = StreamProvider<Map<DateTime, int>>((ref) {
  return ref.watch(statsRepositoryProvider).watchCalendarHeat();
});

final streakProvider = StreamProvider<int>((ref) {
  return ref.watch(statsRepositoryProvider).watchCurrentStreakDays();
});
