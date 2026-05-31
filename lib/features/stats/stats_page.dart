import 'package:eng_card/features/stats/stats_providers.dart';
import 'package:eng_card/widgets/app_ui.dart';
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

    return EngPage(
      title: '统计',
      subtitle: 'Learning records',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          overviewAsync.when(
            data: (overview) {
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _MetricPanel(
                    icon: Icons.layers_outlined,
                    label: '总会话',
                    value: '${overview.totalSessions}',
                  ),
                  _MetricPanel(
                    icon: Icons.check_circle_outline,
                    label: '已完成',
                    value: '${overview.completedSessions}',
                  ),
                  _MetricPanel(
                    icon: Icons.replay_circle_filled_outlined,
                    label: 'Reset',
                    value: '${overview.totalResets}',
                  ),
                  _MetricPanel(
                    icon: Icons.remove_done_outlined,
                    label: 'Over',
                    value: '${overview.totalOvers}',
                  ),
                ],
              );
            },
            error: (error, _) => _ErrorText(message: '总览加载失败：$error'),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
          const SizedBox(height: 16),
          _SectionPanel(
            icon: Icons.show_chart_rounded,
            title: '最近30天完成趋势',
            child: trendAsync.when(
              data: (trend) {
                final points = trend.asMap().entries.map((entry) {
                  return FlSpot(
                    entry.key.toDouble(),
                    entry.value.completions.toDouble(),
                  );
                }).toList();
                return SizedBox(
                  height: 190,
                  child: LineChart(
                    LineChartData(
                      minY: 0,
                      gridData: FlGridData(
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Theme.of(context).colorScheme.outlineVariant,
                            strokeWidth: 1,
                          );
                        },
                      ),
                      borderData: FlBorderData(show: false),
                      lineTouchData: const LineTouchData(enabled: true),
                      lineBarsData: [
                        LineChartBarData(
                          spots: points,
                          isCurved: true,
                          color: Theme.of(context).colorScheme.primary,
                          dotData: const FlDotData(show: false),
                          barWidth: 3,
                          belowBarData: BarAreaData(
                            show: true,
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.10),
                          ),
                        ),
                      ],
                      titlesData: const FlTitlesData(
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                    ),
                  ),
                );
              },
              error: (error, _) => _ErrorText(message: '趋势加载失败：$error'),
              loading: () => const SizedBox(
                height: 190,
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _SectionPanel(
            icon: Icons.calendar_month_outlined,
            title: '学习日历',
            child: heatAsync.when(
              data: (heatMap) {
                return TableCalendar<void>(
                  firstDay: DateTime.now().subtract(const Duration(days: 365)),
                  lastDay: DateTime.now().add(const Duration(days: 365)),
                  focusedDay: DateTime.now(),
                  rowHeight: 42,
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                  calendarStyle: const CalendarStyle(outsideDaysVisible: false),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) =>
                        _HeatDay(day: day, heatMap: heatMap),
                    todayBuilder: (context, day, focusedDay) =>
                        _HeatDay(day: day, heatMap: heatMap, today: true),
                  ),
                );
              },
              error: (error, _) => _ErrorText(message: '日历加载失败：$error'),
              loading: () => const SizedBox(
                height: 300,
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
          const SizedBox(height: 16),
          rankingAsync.when(
            data: (items) {
              return _SectionPanel(
                icon: Icons.leaderboard_outlined,
                title: '卡片组学习排行',
                child: _RankList(
                  emptyText: '暂无排行数据',
                  children: items
                      .map(
                        (item) => _StatListTile(
                          icon: Icons.folder_copy_outlined,
                          title: item.deckName,
                          trailing: '完成 ${item.completedSessions} 次',
                        ),
                      )
                      .toList(),
                ),
              );
            },
            error: (error, _) => _ErrorText(message: '排行加载失败：$error'),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
          const SizedBox(height: 16),
          difficultAsync.when(
            data: (items) {
              return _SectionPanel(
                icon: Icons.local_fire_department_outlined,
                title: '困难卡片榜',
                child: _RankList(
                  emptyText: '暂无困难卡片',
                  children: items
                      .map(
                        (item) => _StatListTile(
                          icon: Icons.style_outlined,
                          title: item.title,
                          subtitle:
                              'Reset ${item.resetCount} · Over ${item.overCount}',
                        ),
                      )
                      .toList(),
                ),
              );
            },
            error: (error, _) => _ErrorText(message: '困难卡加载失败：$error'),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
          const SizedBox(height: 16),
          streakAsync.when(
            data: (streak) => _SectionPanel(
              icon: Icons.bolt_outlined,
              title: '连续学习',
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '更新于 ${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Text(
                    '$streak 天',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            error: (error, _) => _ErrorText(message: '连续天数加载失败：$error'),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }
}

class _MetricPanel extends StatelessWidget {
  const _MetricPanel({
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
      child: EngPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EngIconBadge(icon: icon),
            const SizedBox(height: 14),
            Text(label, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionPanel extends StatelessWidget {
  const _SectionPanel({
    required this.icon,
    required this.title,
    required this.child,
  });

  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return EngPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              EngIconBadge(icon: icon),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _HeatDay extends StatelessWidget {
  const _HeatDay({
    required this.day,
    required this.heatMap,
    this.today = false,
  });

  final DateTime day;
  final Map<DateTime, int> heatMap;
  final bool today;

  @override
  Widget build(BuildContext context) {
    final key = DateTime(day.year, day.month, day.day);
    final count = heatMap[key] ?? 0;
    final level = (count / 8).clamp(0.0, 1.0);
    final scheme = Theme.of(context).colorScheme;
    final color = Color.lerp(scheme.surfaceContainer, scheme.primary, level)!;
    return Container(
      margin: const EdgeInsets.all(4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: today ? scheme.secondary.withValues(alpha: 0.22) : color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text('${day.day}'),
    );
  }
}

class _RankList extends StatelessWidget {
  const _RankList({required this.emptyText, required this.children});

  final String emptyText;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      return Text(emptyText, style: Theme.of(context).textTheme.bodyMedium);
    }
    return Column(children: children);
  }
}

class _StatListTile extends StatelessWidget {
  const _StatListTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: EngIconBadge(icon: icon),
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle!),
      trailing: trailing == null ? null : Text(trailing!),
    );
  }
}

class _ErrorText extends StatelessWidget {
  const _ErrorText({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: TextStyle(color: Theme.of(context).colorScheme.error),
    );
  }
}
