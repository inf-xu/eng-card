import 'package:eng_card/app/providers.dart';
import 'package:eng_card/data/local/app_database.dart';
import 'package:eng_card/widgets/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CardEditPage extends ConsumerStatefulWidget {
  const CardEditPage({super.key, this.editingCard});

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
    _titleController = TextEditingController(
      text: widget.editingCard?.title ?? '',
    );
    _answerController = TextEditingController(
      text: widget.editingCard?.answer ?? '',
    );
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
    final isEditing = widget.editingCard != null;

    return EngPage(
      title: isEditing ? '编辑卡片' : '新增卡片',
      subtitle: 'Card editor',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          EngPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: _cardFieldDecoration(
                    context,
                    labelText: '标题（必填）',
                    prefixIcon: Icons.title_outlined,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _answerController,
                  minLines: 5,
                  maxLines: 8,
                  decoration: _cardFieldDecoration(
                    context,
                    labelText: '答案（可选）',
                    prefixIcon: Icons.notes_outlined,
                    alignLabelWithHint: true,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () async {
              final title = _titleController.text.trim();
              final answer = _answerController.text.trim();
              if (title.isEmpty) {
                return;
              }
              if (widget.editingCard == null) {
                if (currentDeckId == null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('请先选择或创建卡片组')));
                  return;
                }
                await ref
                    .read(cardRepositoryProvider)
                    .createCard(
                      deckId: currentDeckId,
                      title: title,
                      answer: answer.isEmpty ? null : answer,
                    );
              } else {
                await ref
                    .read(cardRepositoryProvider)
                    .updateCard(
                      id: widget.editingCard!.id,
                      title: title,
                      answer: answer.isEmpty ? null : answer,
                    );
              }
              if (context.mounted) {
                Navigator.of(context).pop(true);
              }
            },
            icon: const Icon(Icons.save_outlined),
            label: const Text('保存'),
          ),
        ],
      ),
    );
  }

  InputDecoration _cardFieldDecoration(
    BuildContext context, {
    required String labelText,
    required IconData prefixIcon,
    bool alignLabelWithHint = false,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final borderRadius = BorderRadius.circular(8);
    return InputDecoration(
      labelText: labelText,
      prefixIcon: Icon(prefixIcon),
      alignLabelWithHint: alignLabelWithHint,
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: scheme.primary, width: 1.5),
      ),
    );
  }
}
