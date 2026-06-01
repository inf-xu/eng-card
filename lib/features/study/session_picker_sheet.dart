import 'package:eng_card/app/providers.dart';
import 'package:eng_card/core/enums.dart';
import 'package:eng_card/data/local/app_database.dart';
import 'package:eng_card/data/repositories/deck_repository.dart';
import 'package:eng_card/widgets/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SessionPickerResult {
  const SessionPickerResult({
    required this.source,
    required this.count,
    required this.manualCardIds,
    required this.deckIds,
  });

  final SessionSource source;
  final int count;
  final List<int> manualCardIds;
  final List<int> deckIds;
}

class SessionPickerSheet extends ConsumerStatefulWidget {
  const SessionPickerSheet({super.key, required this.initialDeckId});

  final int initialDeckId;

  @override
  ConsumerState<SessionPickerSheet> createState() => _SessionPickerSheetState();
}

class _SessionPickerSheetState extends ConsumerState<SessionPickerSheet> {
  late SessionSource _source;
  late int _count;
  late final Set<int> _selectedDeckIds;
  final Set<int> _selectedCardIds = <int>{};

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
    _selectedDeckIds = <int>{widget.initialDeckId};
  }

  @override
  Widget build(BuildContext context) {
    final decksAsync = ref.watch(decksProvider);

    return SafeArea(
      child: EngPageBackground(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: decksAsync.when(
            data: (decks) {
              final effectiveDeckIds = _selectedDeckIds.isEmpty
                  ? <int>{widget.initialDeckId}
                  : _selectedDeckIds;
              final deckIds = effectiveDeckIds.toList();
              final cardsAsync = ref.watch(
                cardsByDeckIdsProvider(DeckIdsKey(deckIds)),
              );

              return cardsAsync.when(
                data: (cards) => _buildContent(
                  context: context,
                  decks: decks,
                  cards: cards,
                  deckIds: deckIds,
                ),
                error: (error, _) => Center(child: Text('加载失败：$error')),
                loading: () => const Center(child: CircularProgressIndicator()),
              );
            },
            error: (error, _) => Center(child: Text('加载失败：$error')),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }

  Widget _buildContent({
    required BuildContext context,
    required List<DeckWithCount> decks,
    required List<CardItem> cards,
    required List<int> deckIds,
  }) {
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
        _SheetHeader(total: maxCount, selectedDeckCount: deckIds.length),
        const SizedBox(height: 14),
        EngPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle(text: '出题方式'),
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
              const _SectionTitle(text: '卡片组'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: decks.map((item) {
                  final deck = item.deck;
                  final selected = _selectedDeckIds.contains(deck.id);
                  return FilterChip(
                    selected: selected,
                    label: Text('${deck.name} (${item.cardCount})'),
                    onSelected: (value) {
                      setState(() {
                        if (value) {
                          _selectedDeckIds.add(deck.id);
                          return;
                        }
                        if (_selectedDeckIds.length <= 1) {
                          return;
                        }
                        _selectedDeckIds.remove(deck.id);
                        _selectedCardIds.removeWhere(
                          (cardId) => cards.any(
                            (card) =>
                                card.id == cardId && card.deckId == deck.id,
                          ),
                        );
                      });
                    },
                  );
                }).toList(),
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
                      divisions: hasCards && maxCount > 1 ? maxCount - 1 : null,
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
              child: ListView(
                children: _buildManualCardTiles(decks: decks, cards: cards),
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
                    final selectedIds = _source == SessionSource.manual
                        ? _selectedCardIds.take(count).toList()
                        : <int>[];
                    Navigator.of(context).pop(
                      SessionPickerResult(
                        source: _source,
                        count: count,
                        manualCardIds: selectedIds,
                        deckIds: deckIds,
                      ),
                    );
                  },
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('开始'),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildManualCardTiles({
    required List<DeckWithCount> decks,
    required List<CardItem> cards,
  }) {
    final widgets = <Widget>[];
    for (final deck in decks.where(
      (item) => _selectedDeckIds.contains(item.deck.id),
    )) {
      final deckCards = cards
          .where((card) => card.deckId == deck.deck.id)
          .toList();
      if (deckCards.isEmpty) {
        continue;
      }
      widgets.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
          child: Text(
            deck.deck.name,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      );
      for (final card in deckCards) {
        final checked = _selectedCardIds.contains(card.id);
        widgets.add(
          CheckboxListTile(
            dense: true,
            value: checked,
            title: Text(card.title),
            subtitle: card.answer?.isNotEmpty == true
                ? Text(card.answer!)
                : null,
            onChanged: (value) {
              setState(() {
                if (value ?? false) {
                  _selectedCardIds.add(card.id);
                } else {
                  _selectedCardIds.remove(card.id);
                }
              });
            },
          ),
        );
      }
    }
    return widgets;
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  const _SheetHeader({required this.total, required this.selectedDeckCount});

  final int total;
  final int selectedDeckCount;

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
                '选择本轮记忆',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              Text(
                '已选 $selectedDeckCount 个卡片组，共 $total 张卡片',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
