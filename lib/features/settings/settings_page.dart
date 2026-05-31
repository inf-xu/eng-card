import 'package:eng_card/app/providers.dart';
import 'package:eng_card/core/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: settingsAsync.when(
        data: (settings) {
          return ListView(
            children: [
              const ListTile(title: Text('外观模式')),
              RadioGroup<int>(
                groupValue: settings.themeModeIndex,
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  switch (value) {
                    case 0:
                      ref.read(settingsControllerProvider.notifier).updateThemeMode(ThemeMode.system);
                    case 1:
                      ref.read(settingsControllerProvider.notifier).updateThemeMode(ThemeMode.light);
                    case 2:
                      ref.read(settingsControllerProvider.notifier).updateThemeMode(ThemeMode.dark);
                  }
                },
                child: const Column(
                  children: [
                    RadioListTile<int>(value: 0, title: Text('跟随系统')),
                    RadioListTile<int>(value: 1, title: Text('日间模式')),
                    RadioListTile<int>(value: 2, title: Text('夜间模式')),
                  ],
                ),
              ),
              const Divider(height: 1),
              ListTile(
                title: const Text('默认选择卡片数量'),
                subtitle: Text('${settings.defaultSelectionCount}'),
                trailing: SizedBox(
                  width: 180,
                  child: Slider(
                    min: 1,
                    max: 100,
                    divisions: 99,
                    label: '${settings.defaultSelectionCount}',
                    value: settings.defaultSelectionCount.toDouble(),
                    onChanged: (value) {
                      ref.read(settingsControllerProvider.notifier).updateDefaultSelectionCount(value.toInt());
                    },
                  ),
                ),
              ),
              const Divider(height: 1),
              const ListTile(title: Text('默认学习模式')),
              RadioGroup<StudyMode>(
                groupValue: settings.defaultStudyMode,
                onChanged: (value) {
                  if (value != null) {
                    ref.read(settingsControllerProvider.notifier).updateDefaultStudyMode(value);
                  }
                },
                child: const Column(
                  children: [
                    RadioListTile<StudyMode>(value: StudyMode.practice, title: Text('练习模式')),
                    RadioListTile<StudyMode>(value: StudyMode.exam, title: Text('考试模式')),
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
  }
}
