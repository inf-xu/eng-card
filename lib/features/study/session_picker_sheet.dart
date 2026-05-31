import 'package:eng_card/app/providers.dart';
import 'package:eng_card/core/enums.dart';
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
  const SessionPickerSheet({
    super.key,
    required this.deckId,
  });

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
    final defaultCount = ref.read(settingsControllerProvider).valueOrNull?.defaultSelectionCount ?? 30;
    _source = SessionSource.weightedRandom;
    _count = defaultCount;
  }

  @override
  Widget build(BuildContext context) {
    final cardsAsync = ref.watch(cardsByDeckProvider(widget.deckId));

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: cardsAsync.when(
          data: (cards) {
            final maxCount = cards.length;
            final count = _count.clamp(1, maxCount == 0 ? 1 : maxCount);
            if (_count != count) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() {
                    _count = count;
                  });
                }
              });
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('选择本轮记忆卡片', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                SegmentedButton<SessionSource>(
                  segments: const [
                    ButtonSegment(value: SessionSource.manual, label: Text('自选')),
                    ButtonSegment(value: SessionSource.weightedRandom, label: Text('随机')),
                    ButtonSegment(value: SessionSource.sequential, label: Text('顺序')),
                  ],
                  selected: {_source},
                  onSelectionChanged: (values) {
                    setState(() {
                      _source = values.first;
                    });
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('数量'),
                    Expanded(
                      child: Slider(
                        min: 1,
                        max: maxCount <= 1 ? 1 : maxCount.toDouble(),
                        divisions: maxCount <= 1 ? 1 : maxCount - 1,
                        value: count.toDouble(),
                        label: '$count',
                        onChanged: (value) {
                          setState(() {
                            _count = value.toInt();
                          });
                        },
                      ),
                    ),
                    Text('$count / $maxCount'),
                  ],
                ),
                if (_source == SessionSource.manual)
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: cards.length,
                      itemBuilder: (context, index) {
                        final card = cards[index];
                        final checked = _selected.contains(card.id);
                        return CheckboxListTile(
                          dense: true,
                          value: checked,
                          title: Text(card.title),
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
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: cards.isEmpty
                        ? null
                        : () {
                            final selectedIds = _source == SessionSource.manual
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
                    child: const Text('开始本轮记忆'),
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
    );
  }
}
