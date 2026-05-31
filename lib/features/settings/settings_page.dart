import 'package:eng_card/app/providers.dart';
import 'package:eng_card/core/enums.dart';
import 'package:eng_card/widgets/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsControllerProvider);

    return EngPage(
      title: '设置',
      subtitle: 'Preferences',
      child: settingsAsync.when(
        data: (settings) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              _SettingSection(
                icon: Icons.contrast_outlined,
                title: '外观模式',
                child: SegmentedButton<int>(
                  segments: const [
                    ButtonSegment(
                      value: 0,
                      icon: Icon(Icons.brightness_auto_outlined),
                      label: Text('系统'),
                    ),
                    ButtonSegment(
                      value: 1,
                      icon: Icon(Icons.light_mode_outlined),
                      label: Text('日间'),
                    ),
                    ButtonSegment(
                      value: 2,
                      icon: Icon(Icons.dark_mode_outlined),
                      label: Text('夜间'),
                    ),
                  ],
                  selected: {settings.themeModeIndex},
                  onSelectionChanged: (values) {
                    switch (values.first) {
                      case 0:
                        ref
                            .read(settingsControllerProvider.notifier)
                            .updateThemeMode(ThemeMode.system);
                      case 1:
                        ref
                            .read(settingsControllerProvider.notifier)
                            .updateThemeMode(ThemeMode.light);
                      case 2:
                        ref
                            .read(settingsControllerProvider.notifier)
                            .updateThemeMode(ThemeMode.dark);
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              _SettingSection(
                icon: Icons.format_list_numbered_outlined,
                title: '默认选择数量',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            min: 1,
                            max: 100,
                            divisions: 99,
                            label: '${settings.defaultSelectionCount}',
                            value: settings.defaultSelectionCount.toDouble(),
                            onChanged: (value) {
                              ref
                                  .read(settingsControllerProvider.notifier)
                                  .updateDefaultSelectionCount(value.toInt());
                            },
                          ),
                        ),
                        SizedBox(
                          width: 56,
                          child: Text(
                            '${settings.defaultSelectionCount}',
                            textAlign: TextAlign.right,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '新建学习会话时默认请求的卡片数量。',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _SettingSection(
                icon: Icons.school_outlined,
                title: '默认学习模式',
                child: SegmentedButton<StudyMode>(
                  segments: const [
                    ButtonSegment(
                      value: StudyMode.practice,
                      icon: Icon(Icons.visibility_outlined),
                      label: Text('练习'),
                    ),
                    ButtonSegment(
                      value: StudyMode.exam,
                      icon: Icon(Icons.quiz_outlined),
                      label: Text('考试'),
                    ),
                  ],
                  selected: {settings.defaultStudyMode},
                  onSelectionChanged: (values) {
                    ref
                        .read(settingsControllerProvider.notifier)
                        .updateDefaultStudyMode(values.first);
                  },
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

class _SettingSection extends StatelessWidget {
  const _SettingSection({
    required this.icon,
    required this.title,
    required this.child,
  });

  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return EngPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              EngIconBadge(icon: icon),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
