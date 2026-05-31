import 'package:eng_card/app/providers.dart';
import 'package:eng_card/features/decks/card_edit_page.dart';
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
          title: '请先选择卡片组',
          message: '卡片需要归属于一个卡片组。',
        ),
      );
    }

    final cardsAsync = ref.watch(cardsByDeckProvider(deckId));
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
        label: const Text('新增卡片'),
      ),
      child: cardsAsync.when(
        data: (cards) {
          if (cards.isEmpty) {
            return const EngEmptyState(
              icon: Icons.style_outlined,
              title: '当前卡片组暂无卡片',
              message: '这个主题还没有写入任何记忆内容。',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            itemBuilder: (context, index) {
              final card = cards[index];
              return EngPanel(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const EngIconBadge(icon: Icons.style_outlined),
                  title: Text(card.title),
                  subtitle: Text(
                    card.answer?.isEmpty ?? true ? '（无答案）' : card.answer!,
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => CardEditPage(editingCard: card),
                      ),
                    );
                  },
                  trailing: IconButton(
                    tooltip: '删除卡片',
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () async {
                      await ref
                          .read(cardRepositoryProvider)
                          .deleteCard(card.id);
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
