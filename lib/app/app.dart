import 'package:eng_card/app/app_shell.dart';
import 'package:eng_card/app/providers.dart';
import 'package:eng_card/app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EngCardApp extends ConsumerWidget {
  const EngCardApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsControllerProvider);
    final themeMode = settingsAsync.when(
      data: (_) => ref.read(settingsControllerProvider.notifier).readThemeMode(),
      loading: () => ThemeMode.system,
      error: (_, _) => ThemeMode.system,
    );

    return MaterialApp(
      title: '英格卡',
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: themeMode,
      home: const AppShell(),
      debugShowCheckedModeBanner: false,
    );
  }
}
