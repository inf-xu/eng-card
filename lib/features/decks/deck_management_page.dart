import 'package:eng_card/app/providers.dart';
import 'package:eng_card/widgets/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeckManagementPage extends ConsumerWidget {
  const DeckManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decksAsync = ref.watch(decksProvider);

    return EngPage(
      title: '卡片组管理',
      subtitle: 'Decks',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showDeckInputDialog(
            context,
            onSubmit: (text) async {
              final id = await ref
                  .read(deckRepositoryProvider)
                  .createDeck(text);
              await ref
                  .read(settingsControllerProvider.notifier)
                  .updateCurrentDeckId(id);
            },
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('新增卡片组'),
      ),
      child: decksAsync.when(
        data: (decks) {
          if (decks.isEmpty) {
            return const EngEmptyState(
              icon: Icons.folder_open_outlined,
              title: '暂无卡片组',
              message: '还没有用于归类记忆内容的主题。',
            );
          }

          final currentDeckId = ref.watch(currentDeckIdProvider);
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            itemBuilder: (context, index) {
              final item = decks[index];
              final selected = currentDeckId == item.deck.id;
              return EngPanel(
                color: selected
                    ? Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.12)
                    : null,
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: EngIconBadge(
                    icon: selected ? Icons.check_circle : Icons.folder_outlined,
                    color: selected
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                  title: Text(item.deck.name),
                  subtitle: Text('卡片数量：${item.cardCount}'),
                  onTap: () async {
                    await ref
                        .read(settingsControllerProvider.notifier)
                        .updateCurrentDeckId(item.deck.id);
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'edit') {
                        await _showDeckInputDialog(
                          context,
                          initial: item.deck.name,
                          onSubmit: (text) {
                            return ref
                                .read(deckRepositoryProvider)
                                .updateDeck(item.deck.id, text);
                          },
                        );
                        return;
                      }

                      await ref
                          .read(deckRepositoryProvider)
                          .deleteDeck(item.deck.id);
                      if (currentDeckId == item.deck.id) {
                        await ref
                            .read(settingsControllerProvider.notifier)
                            .updateCurrentDeckId(null);
                      }
                    },
                    itemBuilder: (context) {
                      return const [
                        PopupMenuItem(value: 'edit', child: Text('编辑')),
                        PopupMenuItem(value: 'delete', child: Text('删除')),
                      ];
                    },
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemCount: decks.length,
          );
        },
        error: (error, _) => Center(child: Text('加载失败：$error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Future<void> _showDeckInputDialog(
    BuildContext context, {
    String initial = '',
    required Future<void> Function(String text) onSubmit,
  }) async {
    final controller = TextEditingController(text: initial);
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(initial.isEmpty ? '新增卡片组' : '编辑卡片组'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: '名称'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () async {
                final text = controller.text.trim();
                if (text.isEmpty) {
                  return;
                }
                await onSubmit(text);
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('保存'),
            ),
          ],
        );
      },
    );
  }
}
