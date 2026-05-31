import 'package:eng_card/app/providers.dart';
import 'package:eng_card/core/enums.dart';
import 'package:eng_card/widgets/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SessionPickerResult {
  const SessionPickerResult({
    required this.source,
    required this.count,
    required this.manualCardIds,
  });

  final SessionSource source;
  final int count;
  final List<int> manualCardIds;
}

class SessionPickerSheet extends ConsumerStatefulWidget {
  const SessionPickerSheet({super.key, required this.deckId});

  final int deckId;

  @override
  ConsumerState<SessionPickerSheet> createState() => _SessionPickerSheetState();
}

class _SessionPickerSheetState extends ConsumerState<SessionPickerSheet> {
  late SessionSource _source;
  late int _count;
  final Set<int> _selected = <int>{};

  @override
  void initState() {
    super.initState();
    final defaultCount =
        ref
            .read(settingsControllerProvider)
            .valueOrNull
            ?.defaultSelectionCount ??
        30;
    _source = SessionSource.weightedRandom;
    _count = defaultCount;
  }

  @override
  Widget build(BuildContext context) {
    final cardsAsync = ref.watch(cardsByDeckProvider(widget.deckId));

    return SafeArea(
      child: EngPageBackground(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: cardsAsync.when(
            data: (cards) {
              final maxCount = cards.length;
              final hasCards = maxCount > 0;
              final count = hasCards ? _count.clamp(1, maxCount) : 0;
              if (hasCards && _count != count) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    setState(() {
                      _count = count;
                    });
                  }
                });
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SheetHeader(total: maxCount),
                  const SizedBox(height: 14),
                  EngPanel(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '选择方式',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: SegmentedButton<SessionSource>(
                            segments: const [
                              ButtonSegment(
                                value: SessionSource.manual,
                                icon: Icon(Icons.checklist_outlined),
                                label: Text('自选'),
                              ),
                              ButtonSegment(
                                value: SessionSource.weightedRandom,
                                icon: Icon(Icons.shuffle_rounded),
                                label: Text('随机'),
                              ),
                              ButtonSegment(
                                value: SessionSource.sequential,
                                icon: Icon(Icons.sort_rounded),
                                label: Text('顺序'),
                              ),
                            ],
                            selected: {_source},
                            onSelectionChanged: (values) {
                              setState(() {
                                _source = values.first;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Text('数量'),
                            Expanded(
                              child: Slider(
                                min: hasCards ? 1 : 0,
                                max: hasCards
                                    ? (maxCount <= 1 ? 1 : maxCount.toDouble())
                                    : 1,
                                divisions: hasCards && maxCount > 1
                                    ? maxCount - 1
                                    : null,
                                value: count.toDouble(),
                                label: '$count',
                                onChanged: hasCards
                                    ? (value) {
                                        setState(() {
                                          _count = value.toInt();
                                        });
                                      }
                                    : null,
                              ),
                            ),
                            Text(
                              '$count / $maxCount',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_source == SessionSource.manual)
                    Expanded(
                      child: EngPanel(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: ListView.builder(
                          itemCount: cards.length,
                          itemBuilder: (context, index) {
                            final card = cards[index];
                            final checked = _selected.contains(card.id);
                            return CheckboxListTile(
                              dense: true,
                              value: checked,
                              title: Text(card.title),
                              subtitle: card.answer?.isNotEmpty == true
                                  ? Text(card.answer!)
                                  : null,
                              onChanged: (value) {
                                setState(() {
                                  if (value ?? false) {
                                    _selected.add(card.id);
                                  } else {
                                    _selected.remove(card.id);
                                  }
                                });
                              },
                            );
                          },
                        ),
                      ),
                    )
                  else
                    const Spacer(),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: cards.isEmpty
                          ? null
                          : () {
                              final selectedIds =
                                  _source == SessionSource.manual
                                  ? _selected.take(count).toList()
                                  : <int>[];
                              Navigator.of(context).pop(
                                SessionPickerResult(
                                  source: _source,
                                  count: count,
                                  manualCardIds: selectedIds,
                                ),
                              );
                            },
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text('开始本轮记忆'),
                    ),
                  ),
                ],
              );
            },
            error: (error, _) => Text('加载失败：$error'),
            loading: () => const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  const _SheetHeader({required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const EngIconBadge(icon: Icons.auto_stories_outlined),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '选择本轮记忆卡片',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              Text(
                '当前卡片组共 $total 张卡片',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
