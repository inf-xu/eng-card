import 'package:eng_card/app/providers.dart';
import 'package:eng_card/data/repositories/stats_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final overviewStatsProvider = FutureProvider<OverviewStats>((ref) {
  return ref.watch(statsRepositoryProvider).loadOverview();
});

final trendStatsProvider = FutureProvider<List<DailyTrendPoint>>((ref) {
  return ref.watch(statsRepositoryProvider).loadTrend(days: 30);
});

final deckRankingProvider = FutureProvider<List<DeckRankItem>>((ref) {
  return ref.watch(statsRepositoryProvider).loadDeckRanking(limit: 5);
});

final difficultCardsProvider = FutureProvider<List<DifficultCardItem>>((ref) {
  return ref.watch(statsRepositoryProvider).loadDifficultCards(limit: 5);
});

final calendarHeatProvider = FutureProvider<Map<DateTime, int>>((ref) {
  return ref.watch(statsRepositoryProvider).loadCalendarHeat();
});

final streakProvider = FutureProvider<int>((ref) {
  return ref.watch(statsRepositoryProvider).currentStreakDays();
});
