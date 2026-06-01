import 'package:eng_card/data/repositories/bootstrap_repository.dart';
import 'package:eng_card/core/enums.dart';
import 'package:eng_card/data/local/app_database.dart';
import 'package:eng_card/data/repositories/card_repository.dart';
import 'package:eng_card/data/repositories/deck_repository.dart';
import 'package:eng_card/data/repositories/settings_repository.dart';
import 'package:eng_card/data/repositories/stats_repository.dart';
import 'package:eng_card/data/repositories/study_session_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final deckRepositoryProvider = Provider<DeckRepository>((ref) {
  return DeckRepository(ref.watch(appDatabaseProvider));
});

final cardRepositoryProvider = Provider<CardRepository>((ref) {
  return CardRepository(ref.watch(appDatabaseProvider));
});

final sessionRepositoryProvider = Provider<StudySessionRepository>((ref) {
  return StudySessionRepository(ref.watch(appDatabaseProvider));
});

final statsRepositoryProvider = Provider<StatsRepository>((ref) {
  return StatsRepository(ref.watch(appDatabaseProvider));
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository();
});

final bootstrapRepositoryProvider = Provider<BootstrapRepository>((ref) {
  return BootstrapRepository(ref.watch(appDatabaseProvider));
});

final appBootstrapProvider = FutureProvider<void>((ref) async {
  final settingsController = ref.read(settingsControllerProvider.notifier);
  final settings = await ref.read(settingsControllerProvider.future);
  if (!settings.hasSeededIpaDeck) {
    final deckId = await ref
        .read(bootstrapRepositoryProvider)
        .seedIpaDeckFromAsset();
    final nextSettings = settings.copyWith(hasSeededIpaDeck: true);
    settingsController.state = AsyncValue.data(nextSettings);
    await ref.read(settingsRepositoryProvider).save(nextSettings);
    if (settings.currentDeckId == null && deckId != null) {
      await settingsController.updateCurrentDeckId(deckId);
    }
  }
});

final settingsControllerProvider =
    AsyncNotifierProvider<SettingsController, AppSettings>(
      SettingsController.new,
    );

class SettingsController extends AsyncNotifier<AppSettings> {
  @override
  Future<AppSettings> build() {
    return ref.watch(settingsRepositoryProvider).load();
  }

  Future<void> updateThemeMode(ThemeMode themeMode) async {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }
    final next = current.copyWith(themeModeIndex: _themeModeToIndex(themeMode));
    state = AsyncValue.data(next);
    await ref.watch(settingsRepositoryProvider).save(next);
  }

  Future<void> updateDefaultSelectionCount(int count) async {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }
    final next = current.copyWith(defaultSelectionCount: count.clamp(1, 300));
    state = AsyncValue.data(next);
    await ref.watch(settingsRepositoryProvider).save(next);
  }

  Future<void> updateDefaultStudyMode(StudyMode mode) async {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }
    final next = current.copyWith(defaultStudyMode: mode);
    state = AsyncValue.data(next);
    await ref.watch(settingsRepositoryProvider).save(next);
  }

  Future<void> updateCurrentDeckId(int? deckId) async {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }
    final next = current.copyWith(
      currentDeckId: deckId,
      clearCurrentDeckId: deckId == null,
    );
    state = AsyncValue.data(next);
    await ref.watch(settingsRepositoryProvider).save(next);
  }

  ThemeMode readThemeMode() {
    final settings = state.valueOrNull;
    if (settings == null) {
      return ThemeMode.system;
    }
    return _themeModeFromIndex(settings.themeModeIndex);
  }

  int _themeModeToIndex(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 0;
      case ThemeMode.light:
        return 1;
      case ThemeMode.dark:
        return 2;
    }
  }

  ThemeMode _themeModeFromIndex(int index) {
    switch (index) {
      case 1:
        return ThemeMode.light;
      case 2:
        return ThemeMode.dark;
      case 0:
      default:
        return ThemeMode.system;
    }
  }
}

final decksProvider = StreamProvider<List<DeckWithCount>>((ref) {
  return ref.watch(deckRepositoryProvider).watchDecks();
});

final cardsByDeckProvider = StreamProvider.family<List<CardItem>, int>((
  ref,
  deckId,
) {
  return ref.watch(cardRepositoryProvider).watchCardsByDeck(deckId);
});

final currentDeckIdProvider = Provider<int?>((ref) {
  return ref.watch(settingsControllerProvider).valueOrNull?.currentDeckId;
});
