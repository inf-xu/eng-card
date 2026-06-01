import 'package:eng_card/app/providers.dart';
import 'package:eng_card/data/repositories/card_repository.dart';
import 'package:eng_card/features/decks/card_edit_page.dart';
import 'package:eng_card/features/study/study_controller.dart';
import 'package:eng_card/widgets/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CardManagementPage extends ConsumerWidget {
  const CardManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deckId = ref.watch(currentDeckIdProvider);
    if (deckId == null) {
      return const EngPage(
        title: '卡片管理',
        subtitle: 'Cards',
        child: EngEmptyState(
          icon: Icons.folder_copy_outlined,
          title: '未选择卡片组',
          message: '请先选择一个卡片组。',
        ),
      );
    }

    final cardsAsync = ref.watch(cardsByDeckProvider(deckId));
    final studyState = ref.watch(studyControllerProvider);
    final lockedCardIds =
        studyState.valueOrNull?.sessionData?.cards
            .map((card) => card.cardId)
            .toSet() ??
        const <int>{};

    return EngPage(
      title: '卡片管理',
      subtitle: 'Cards',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const CardEditPage()));
        },
        icon: const Icon(Icons.add),
        label: const Text('新建'),
      ),
      child: cardsAsync.when(
        data: (cards) {
          if (cards.isEmpty) {
            return const EngEmptyState(
              icon: Icons.style_outlined,
              title: '暂无卡片',
              message: '点击右下角按钮创建第一张卡片。',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            itemBuilder: (context, index) {
              final card = cards[index];
              final isLocked = lockedCardIds.contains(card.id);
              return EngPanel(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const EngIconBadge(icon: Icons.style_outlined),
                  title: Text(card.title),
                  subtitle: Text(
                    isLocked ? '本轮记忆中，暂不可修改/删除' : (card.answer ?? ''),
                  ),
                  onTap: isLocked
                      ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('本轮记忆选中的单词不可修改')),
                          );
                        }
                      : () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => CardEditPage(editingCard: card),
                            ),
                          );
                        },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: isLocked
                        ? null
                        : () async {
                            try {
                              await ref
                                  .read(cardRepositoryProvider)
                                  .deleteCard(card.id);
                            } on ActiveSessionCardLockedException {
                              if (!context.mounted) {
                                return;
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('本轮记忆选中的单词不可删除')),
                              );
                            }
                          },
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemCount: cards.length,
          );
        },
        error: (error, _) => Center(child: Text('加载失败：$error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
