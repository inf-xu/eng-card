import 'package:eng_card/app/providers.dart';
import 'package:eng_card/data/local/app_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CardEditPage extends ConsumerStatefulWidget {
  const CardEditPage({
    super.key,
    this.editingCard,
  });

  final CardItem? editingCard;

  @override
  ConsumerState<CardEditPage> createState() => _CardEditPageState();
}

class _CardEditPageState extends ConsumerState<CardEditPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _answerController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.editingCard?.title ?? '');
    _answerController = TextEditingController(text: widget.editingCard?.answer ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentDeckId = ref.watch(currentDeckIdProvider);

    return Scaffold(
      appBar: AppBar(title: Text(widget.editingCard == null ? '新增卡片' : '编辑卡片')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: '标题（必填）'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _answerController,
              minLines: 3,
              maxLines: 6,
              decoration: const InputDecoration(labelText: '答案（可选）'),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () async {
                  final title = _titleController.text.trim();
                  final answer = _answerController.text.trim();
                  if (title.isEmpty) {
                    return;
                  }
                  if (widget.editingCard == null) {
                    if (currentDeckId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('请先选择或创建卡片组')),
                      );
                      return;
                    }
                    await ref.read(cardRepositoryProvider).createCard(
                          deckId: currentDeckId,
                          title: title,
                          answer: answer.isEmpty ? null : answer,
                        );
                  } else {
                    await ref.read(cardRepositoryProvider).updateCard(
                          id: widget.editingCard!.id,
                          title: title,
                          answer: answer.isEmpty ? null : answer,
                        );
                  }
                  if (context.mounted) {
                    Navigator.of(context).pop(true);
                  }
                },
                child: const Text('保存'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
