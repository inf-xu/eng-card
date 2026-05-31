import 'package:eng_card/app/providers.dart';
import 'package:eng_card/core/enums.dart';
import 'package:eng_card/features/decks/card_edit_page.dart';
import 'package:eng_card/features/decks/card_management_page.dart';
import 'package:eng_card/features/decks/deck_management_page.dart';
import 'package:eng_card/features/study/session_picker_sheet.dart';
import 'package:eng_card/features/study/study_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final PageController _pageController = PageController(initialPage: 1000);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final decksAsync = ref.watch(decksProvider);
    final currentDeckId = ref.watch(currentDeckIdProvider);

    return decksAsync.when(
      data: (decks) {
        final hasDeck = decks.isNotEmpty;
        final validDeckId = currentDeckId != null && decks.any((deck) => deck.deck.id == currentDeckId);

        if (!hasDeck || !validDeckId) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('英格卡'),
              actions: [
                IconButton(
                  tooltip: '新增卡片',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const CardEditPage()),
                    );
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.style_outlined, size: 72),
                    const SizedBox(height: 12),
                    const Text('还没有可学习的卡片组', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    const Text('请先创建并选择卡片组，然后添加卡片。', textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const DeckManagementPage()),
                        );
                      },
                      icon: const Icon(Icons.folder_open),
                      label: const Text('去管理卡片组'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final deckId = currentDeckId;
        final studyState = ref.watch(studyControllerProvider(deckId));

        return Scaffold(
          appBar: AppBar(
            title: Text('英格卡 · ${decks.firstWhere((deck) => deck.deck.id == deckId).deck.name}'),
            leading: IconButton(
              tooltip: '卡片组管理',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const DeckManagementPage()),
                );
              },
              icon: const Icon(Icons.folder_copy_outlined),
            ),
            actions: [
              IconButton(
                tooltip: '新增卡片',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CardEditPage()),
                  );
                },
                icon: const Icon(Icons.add_card_outlined),
              ),
              IconButton(
                tooltip: '卡片管理',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CardManagementPage()),
                  );
                },
                icon: const Icon(Icons.list_alt_outlined),
              ),
              IconButton(
                tooltip: '切换模式',
                onPressed: () async {
                  await ref.read(studyControllerProvider(deckId).notifier).toggleMode();
                },
                icon: const Icon(Icons.swap_horiz),
              ),
            ],
          ),
          body: studyState.when(
            data: (data) {
              final session = data.sessionData;
              final cards = session?.activeCards ?? const [];
              if (session == null || cards.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('当前模式：${data.mode.text}'),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: () => _startSession(context, deckId),
                        icon: const Icon(Icons.play_circle_outline),
                        label: const Text('选择本轮记忆卡片'),
                      ),
                    ],
                  ),
                );
              }

              final currentCard = data.currentCard;
              if (currentCard == null) {
                return const Center(child: Text('本轮已完成，开始下一轮吧。'));
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Chip(label: Text('模式：${data.mode.text}')),
                        const SizedBox(width: 8),
                        Chip(label: Text('剩余：${cards.length}')),
                        const Spacer(),
                        TextButton(
                          onPressed: () => _startSession(context, deckId),
                          child: const Text('重选卡片'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (page) {
                        ref.read(studyControllerProvider(deckId).notifier).onPageChanged(page);
                      },
                      itemBuilder: (context, index) {
                        final card = cards[index % cards.length];
                        final visible = data.isAnswerVisible(card.cardId);
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(18),
                            onTap: () {
                              ref.read(studyControllerProvider(deckId).notifier).revealAnswer();
                            },
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(card.title, style: Theme.of(context).textTheme.headlineSmall),
                                    const SizedBox(height: 16),
                                    if (visible)
                                      Text(card.answer ?? '（无答案）', style: Theme.of(context).textTheme.titleMedium)
                                    else
                                      const Text('点击卡片显示答案'),
                                    const Spacer(),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text('卡片 ID: ${card.cardId}'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              await ref.read(studyControllerProvider(deckId).notifier).resetCurrentCard();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('已标记为继续学习')));
                              }
                            },
                            child: const Text('Reset'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            onPressed: () async {
                              await ref.read(studyControllerProvider(deckId).notifier).overCurrentCard();
                            },
                            child: const Text('Over'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
            error: (error, _) => Center(child: Text('加载失败：$error')),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        );
      },
      error: (error, _) => Scaffold(body: Center(child: Text('加载失败：$error'))),
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }

  Future<void> _startSession(BuildContext context, int deckId) async {
    final result = await showModalBottomSheet<SessionPickerResult>(
      context: context,
      isScrollControlled: true,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.88,
        child: SessionPickerSheet(deckId: deckId),
      ),
    );
    if (result == null) {
      return;
    }

    await ref.read(studyControllerProvider(deckId).notifier).createSession(
          source: result.source,
          requestedCount: result.count,
          manualCardIds: result.manualCardIds,
        );
  }
}
