import 'package:eng_card/core/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  const AppSettings({
    required this.themeModeIndex,
    required this.defaultSelectionCount,
    required this.defaultStudyMode,
    required this.currentDeckId,
    required this.hasSeededIpaDeck,
  });

  final int themeModeIndex;
  final int defaultSelectionCount;
  final StudyMode defaultStudyMode;
  final int? currentDeckId;
  final bool hasSeededIpaDeck;

  AppSettings copyWith({
    int? themeModeIndex,
    int? defaultSelectionCount,
    StudyMode? defaultStudyMode,
    int? currentDeckId,
    bool clearCurrentDeckId = false,
    bool? hasSeededIpaDeck,
  }) {
    return AppSettings(
      themeModeIndex: themeModeIndex ?? this.themeModeIndex,
      defaultSelectionCount: defaultSelectionCount ?? this.defaultSelectionCount,
      defaultStudyMode: defaultStudyMode ?? this.defaultStudyMode,
      currentDeckId: clearCurrentDeckId ? null : (currentDeckId ?? this.currentDeckId),
      hasSeededIpaDeck: hasSeededIpaDeck ?? this.hasSeededIpaDeck,
    );
  }
}

class SettingsRepository {
  static const _themeModeKey = 'theme_mode';
  static const _defaultSelectionCountKey = 'default_selection_count';
  static const _defaultStudyModeKey = 'default_study_mode';
  static const _currentDeckIdKey = 'current_deck_id';
  static const _hasSeededIpaDeckKey = 'has_seeded_ipa_deck';

  Future<AppSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    final modeIndex = prefs.getInt(_defaultStudyModeKey) ?? StudyMode.practice.index;
    return AppSettings(
      themeModeIndex: prefs.getInt(_themeModeKey) ?? 0,
      defaultSelectionCount: prefs.getInt(_defaultSelectionCountKey) ?? 30,
      defaultStudyMode: StudyMode.values[modeIndex.clamp(0, StudyMode.values.length - 1)],
      currentDeckId: prefs.getInt(_currentDeckIdKey),
      hasSeededIpaDeck: prefs.getBool(_hasSeededIpaDeckKey) ?? false,
    );
  }

  Future<void> save(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeModeKey, settings.themeModeIndex);
    await prefs.setInt(_defaultSelectionCountKey, settings.defaultSelectionCount);
    await prefs.setInt(_defaultStudyModeKey, settings.defaultStudyMode.index);
    if (settings.currentDeckId == null) {
      await prefs.remove(_currentDeckIdKey);
    } else {
      await prefs.setInt(_currentDeckIdKey, settings.currentDeckId!);
    }
    await prefs.setBool(_hasSeededIpaDeckKey, settings.hasSeededIpaDeck);
  }
}
