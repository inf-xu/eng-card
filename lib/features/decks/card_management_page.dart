import 'package:eng_card/app/providers.dart';
import 'package:eng_card/features/decks/card_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CardManagementPage extends ConsumerWidget {
  const CardManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deckId = ref.watch(currentDeckIdProvider);
    if (deckId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('卡片管理')),
        body: const Center(child: Text('请先选择卡片组')),
      );
    }

    final cardsAsync = ref.watch(cardsByDeckProvider(deckId));
    return Scaffold(
      appBar: AppBar(title: const Text('卡片管理')),
      body: cardsAsync.when(
        data: (cards) {
          if (cards.isEmpty) {
            return const Center(child: Text('当前卡片组暂无卡片'));
          }
          return ListView.separated(
            itemBuilder: (context, index) {
              final card = cards[index];
              return ListTile(
                title: Text(card.title),
                subtitle: Text(card.answer?.isEmpty ?? true ? '（无答案）' : card.answer!),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => CardEditPage(editingCard: card)),
                  );
                },
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () async {
                    await ref.read(cardRepositoryProvider).deleteCard(card.id);
                  },
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemCount: cards.length,
          );
        },
        error: (error, _) => Center(child: Text('加载失败：$error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CardEditPage()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('新增卡片'),
      ),
    );
  }
}
