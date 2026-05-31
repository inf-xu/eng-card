import 'package:eng_card/features/stats/stats_providers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overviewAsync = ref.watch(overviewStatsProvider);
    final trendAsync = ref.watch(trendStatsProvider);
    final rankingAsync = ref.watch(deckRankingProvider);
    final difficultAsync = ref.watch(difficultCardsProvider);
    final heatAsync = ref.watch(calendarHeatProvider);
    final streakAsync = ref.watch(streakProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('统计')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          overviewAsync.when(
            data: (overview) {
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _MetricCard(icon: Icons.layers_outlined, label: '总会话', value: '${overview.totalSessions}'),
                  _MetricCard(icon: Icons.check_circle_outline, label: '已完成', value: '${overview.completedSessions}'),
                  _MetricCard(icon: Icons.replay_circle_filled_outlined, label: 'Reset', value: '${overview.totalResets}'),
                  _MetricCard(icon: Icons.remove_done_outlined, label: 'Over', value: '${overview.totalOvers}'),
                ],
              );
            },
            error: (error, _) => Text('总览加载失败：$error'),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
          const SizedBox(height: 16),
          _StatsCard(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: trendAsync.when(
                data: (trend) {
                  final points = trend.asMap().entries.map((entry) {
                    return FlSpot(entry.key.toDouble(), entry.value.completions.toDouble());
                  }).toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('最近30天完成趋势', style: TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 180,
                        child: LineChart(
                          LineChartData(
                            minY: 0,
                            lineBarsData: [
                              LineChartBarData(
                                spots: points,
                                isCurved: true,
                                dotData: const FlDotData(show: false),
                                barWidth: 3,
                              ),
                            ],
                            titlesData: const FlTitlesData(
                              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
                error: (error, _) => Text('趋势加载失败：$error'),
                loading: () => const SizedBox(height: 180, child: Center(child: CircularProgressIndicator())),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _StatsCard(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: heatAsync.when(
                data: (heatMap) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('学习日历', style: TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 12),
                      TableCalendar<void>(
                        firstDay: DateTime.now().subtract(const Duration(days: 365)),
                        lastDay: DateTime.now().add(const Duration(days: 365)),
                        focusedDay: DateTime.now(),
                        calendarBuilders: CalendarBuilders(
                          defaultBuilder: (context, day, focusedDay) {
                            final key = DateTime(day.year, day.month, day.day);
                            final count = heatMap[key] ?? 0;
                            final level = (count / 8).clamp(0.0, 1.0);
                            final color = Color.lerp(Colors.grey.shade200, Theme.of(context).colorScheme.primary, level)!;
                            return Container(
                              margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(child: Text('${day.day}')),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
                error: (error, _) => Text('日历加载失败：$error'),
                loading: () => const SizedBox(height: 300, child: Center(child: CircularProgressIndicator())),
              ),
            ),
          ),
          const SizedBox(height: 16),
          rankingAsync.when(
            data: (items) {
              return _StatsCard(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('卡片组学习排行', style: TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      if (items.isEmpty) const Text('暂无数据'),
                      ...items.map((item) => ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.leaderboard_outlined),
                            title: Text(item.deckName),
                            trailing: Text('完成 ${item.completedSessions} 次'),
                          )),
                    ],
                  ),
                ),
              );
            },
            error: (error, _) => Text('排行加载失败：$error'),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
          const SizedBox(height: 16),
          difficultAsync.when(
            data: (items) {
              return _StatsCard(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('困难卡片榜', style: TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      if (items.isEmpty) const Text('暂无数据'),
                      ...items.map((item) => ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.local_fire_department_outlined),
                            title: Text(item.title),
                            subtitle: Text('Reset ${item.resetCount} · Over ${item.overCount}'),
                          )),
                    ],
                  ),
                ),
              );
            },
            error: (error, _) => Text('困难卡加载失败：$error'),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
          const SizedBox(height: 16),
          streakAsync.when(
            data: (streak) => _StatsCard(
              child: ListTile(
                leading: const Icon(Icons.bolt_outlined),
                title: const Text('连续学习天数'),
                trailing: Text('$streak 天'),
                subtitle: Text('更新于 ${DateFormat('yyyy-MM-dd').format(DateTime.now())}'),
              ),
            ),
            error: (error, _) => Text('连续天数加载失败：$error'),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final width = (MediaQuery.of(context).size.width - 16 * 2 - 12) / 2;
    return SizedBox(
      width: width,
      child: _StatsCard(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon),
              const SizedBox(height: 6),
              Text(label),
              const SizedBox(height: 4),
              Text(value, style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide.none,
      ),
      child: child,
    );
  }
}
