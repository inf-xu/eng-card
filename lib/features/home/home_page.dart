import 'package:eng_card/app/providers.dart';
import 'package:eng_card/core/enums.dart';
import 'package:eng_card/data/repositories/study_session_repository.dart';
import 'package:eng_card/features/decks/card_edit_page.dart';
import 'package:eng_card/features/decks/card_management_page.dart';
import 'package:eng_card/features/decks/deck_management_page.dart';
import 'package:eng_card/features/study/session_picker_sheet.dart';
import 'package:eng_card/features/study/study_controller.dart';
import 'package:eng_card/widgets/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final PageController _pageController = PageController(initialPage: 1000);
  final Map<int, int> _cardIdByPage = <int, int>{};
  bool _isCompletingOver = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final decksAsync = ref.watch(decksProvider);
    final currentDeckId = ref.watch(currentDeckIdProvider);
    final studyState = ref.watch(studyControllerProvider);

    return decksAsync.when(
      data: (decks) {
        final hasDeck = decks.isNotEmpty;
        final validDeckId =
            currentDeckId != null &&
            decks.any((deck) => deck.deck.id == currentDeckId);

        if (!hasDeck || !validDeckId) {
          return EngPage(
            title: '记忆卡片',
            subtitle: 'Memory desk',
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CardEditPage()),
                  );
                },
                icon: const Icon(Icons.add_card_outlined),
              ),
            ],
            child: EngEmptyState(
              icon: Icons.style_outlined,
              title: '还没有可用卡片组',
              message: '先创建卡片组，再添加需要记忆的卡片。',
              action: FilledButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const DeckManagementPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.folder_open),
                label: const Text('管理卡片组'),
              ),
            ),
          );
        }

        final deckId = currentDeckId;
        final deckName = decks
            .firstWhere((deck) => deck.deck.id == deckId)
            .deck
            .name;

        return EngPage(
          title: deckName,
          subtitle: 'Memory desk',
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const DeckManagementPage()),
              );
            },
            icon: const Icon(Icons.folder_copy_outlined),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const CardEditPage()));
              },
              icon: const Icon(Icons.add_card_outlined),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CardManagementPage()),
                );
              },
              icon: const Icon(Icons.list_alt_outlined),
            ),
            IconButton(
              onPressed: () async {
                await ref.read(studyControllerProvider.notifier).toggleMode();
              },
              icon: const Icon(Icons.swap_horiz),
            ),
          ],
          child: studyState.when(
            data: (data) {
              final session = data.sessionData;
              final cards = session?.activeCards ?? const [];
              if (session == null || cards.isEmpty) {
                return EngEmptyState(
                  icon: Icons.play_circle_outline,
                  title: '开始本轮记忆',
                  message: '可以从当前卡片组开始，也可以选择多个卡片组混合记忆。',
                  action: FilledButton.icon(
                    onPressed: () => _startSession(context, deckId),
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text('选择本轮卡片'),
                  ),
                );
              }

              final currentCard = data.currentCard;
              if (currentCard == null) {
                return EngEmptyState(
                  icon: Icons.done_all_outlined,
                  title: '本轮已完成',
                  message: '重新选择卡片后会创建新的全局记忆会话。',
                  action: FilledButton.icon(
                    onPressed: () => _startSession(context, deckId),
                    icon: const Icon(Icons.refresh),
                    label: const Text('重选'),
                  ),
                );
              }
              _cacheCurrentPageCard(data);

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                    child: _StudyStatusBar(
                      mode: data.mode.text,
                      remaining: cards.length,
                      total: session.cards.length,
                      deckCount: session.sourceDeckIds.length,
                      onReselect: () => _startSession(context, deckId),
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (page) {
                        ref
                            .read(studyControllerProvider.notifier)
                            .onPageChanged(page);
                      },
                      itemBuilder: (context, index) {
                        final card = _cardForPage(index, cards);
                        final visible = data.isAnswerVisible(card.cardId);
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                          child: _StudyCard(
                            title: card.title,
                            answer: visible ? card.answer : null,
                            isRevealed: visible,
                            answerPlaceholder: data.isExamMode
                                ? '点击卡片查看答案'
                                : '',
                            cardId: card.cardId,
                            onTap: () {
                              ref
                                  .read(studyControllerProvider.notifier)
                                  .revealAnswer();
                            },
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
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              await ref
                                  .read(studyControllerProvider.notifier)
                                  .resetCurrentCard();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('已记录 Reset')),
                                );
                              }
                            },
                            icon: const Icon(Icons.replay_rounded),
                            label: const Text('Reset'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () async {
                              await _completeCurrentCard(data);
                            },
                            icon: const Icon(Icons.check_rounded),
                            label: const Text('Over'),
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
      error: (error, _) => EngPage(
        title: '记忆卡片',
        subtitle: 'Memory desk',
        child: EngEmptyState(
          icon: Icons.error_outline,
          title: '加载失败',
          message: '$error',
        ),
      ),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }

  Future<void> _startSession(BuildContext context, int deckId) async {
    final result = await showModalBottomSheet<SessionPickerResult>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.88,
        child: SessionPickerSheet(initialDeckId: deckId),
      ),
    );
    if (result == null) {
      return;
    }

    _cardIdByPage.clear();
    await ref
        .read(studyControllerProvider.notifier)
        .createSession(
          source: result.source,
          requestedCount: result.count,
          manualCardIds: result.manualCardIds,
          deckIds: result.deckIds,
        );
  }

  void _cacheCurrentPageCard(StudyViewState data) {
    if (!_pageController.hasClients) {
      return;
    }
    final page = _pageController.page?.round() ?? _pageController.initialPage;
    final card = data.currentCard;
    if (card == null) {
      return;
    }
    _cardIdByPage[page] = card.cardId;
  }

  SessionCardView _cardForPage(int page, List<SessionCardView> cards) {
    final cachedCardId = _cardIdByPage[page];
    if (cachedCardId != null) {
      for (final card in cards) {
        if (card.cardId == cachedCardId) {
          return card;
        }
      }
    }

    final card = cards[page % cards.length];
    _cardIdByPage[page] = card.cardId;
    return card;
  }

  Future<void> _completeCurrentCard(StudyViewState data) async {
    if (_isCompletingOver) {
      return;
    }

    final currentCards =
        data.sessionData?.activeCards ?? const <SessionCardView>[];
    if (currentCards.isEmpty) {
      return;
    }

    _isCompletingOver = true;
    try {
      final currentPage = _pageController.hasClients
          ? (_pageController.page?.round() ?? _pageController.initialPage)
          : data.virtualPage;
      final nextPage = currentPage + 1;
      final overCard = _cardForPage(currentPage, currentCards);
      _cardIdByPage[currentPage] = overCard.cardId;

      if (_pageController.hasClients && currentCards.length > 1) {
        final visualNextCard = _cardForPage(nextPage, currentCards);
        _cardIdByPage[nextPage] = visualNextCard.cardId;
        await _pageController.nextPage(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
        );

        final nextCards = currentCards
            .where((card) => card.sessionCardId != overCard.sessionCardId)
            .toList();
        final normalizedPage = _pageForCardNear(
          page: nextPage,
          cardId: visualNextCard.cardId,
          cards: nextCards,
        );
        if (normalizedPage != null) {
          _cardIdByPage[normalizedPage] = visualNextCard.cardId;
          await ref
              .read(studyControllerProvider.notifier)
              .overCard(
                sessionCardId: overCard.sessionCardId,
                cardId: overCard.cardId,
                nextVirtualPage: normalizedPage,
              );
          if (_pageController.hasClients) {
            _pageController.jumpToPage(normalizedPage);
          }
          return;
        }
      }

      await ref
          .read(studyControllerProvider.notifier)
          .overCard(
            sessionCardId: overCard.sessionCardId,
            cardId: overCard.cardId,
            nextVirtualPage: currentPage,
          );
    } finally {
      _isCompletingOver = false;
    }
  }

  int? _pageForCardNear({
    required int page,
    required int cardId,
    required List<SessionCardView> cards,
  }) {
    if (cards.isEmpty) {
      return null;
    }

    final targetIndex = cards.indexWhere((card) => card.cardId == cardId);
    if (targetIndex < 0) {
      return null;
    }

    final remainder = page % cards.length;
    final delta = targetIndex - remainder;
    return page + delta;
  }
}

class _StudyStatusBar extends StatelessWidget {
  const _StudyStatusBar({
    required this.mode,
    required this.remaining,
    required this.total,
    required this.deckCount,
    required this.onReselect,
  });

  final String mode;
  final int remaining;
  final int total;
  final int deckCount;
  final VoidCallback onReselect;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return EngPanel(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          EngIconBadge(
            icon: Icons.radio_button_checked,
            color: scheme.secondary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(label: Text(mode)),
                Chip(label: Text('$deckCount 组')),
                Chip(label: Text('剩余 $remaining / $total')),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: onReselect,
            icon: const Icon(Icons.shuffle_rounded),
            label: const Text('重选'),
          ),
        ],
      ),
    );
  }
}

class _StudyCard extends StatelessWidget {
  const _StudyCard({
    required this.title,
    required this.answer,
    required this.isRevealed,
    required this.answerPlaceholder,
    required this.cardId,
    required this.onTap,
  });

  final String title;
  final String? answer;
  final bool isRevealed;
  final String answerPlaceholder;
  final int cardId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final answerText = isRevealed ? (answer ?? '') : answerPlaceholder;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 18),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 4,
                  decoration: BoxDecoration(
                    color: scheme.secondary,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const Spacer(),
                Text(
                  '#$cardId',
                  style: textTheme.labelMedium?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.48),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 34),
            Text(
              title,
              style: textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w800,
                height: 1.08,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              answerText,
              style: textTheme.titleMedium?.copyWith(
                color: isRevealed
                    ? scheme.onSurface
                    : scheme.onSurface.withValues(alpha: 0.52),
                height: 1.45,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Icon(
                  Icons.swipe_rounded,
                  size: 18,
                  color: scheme.onSurface.withValues(alpha: 0.42),
                ),
                const SizedBox(width: 6),
                Text(
                  '左右滑动切换卡片',
                  style: textTheme.labelMedium?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.48),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
