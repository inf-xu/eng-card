import 'package:eng_card/core/enums.dart';
import 'package:eng_card/data/repositories/settings_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('SettingsRepository', () {
    test('load default values when preference is empty', () async {
      SharedPreferences.setMockInitialValues({});
      final repo = SettingsRepository();
      final settings = await repo.load();

      expect(settings.defaultSelectionCount, 30);
      expect(settings.defaultStudyMode, StudyMode.practice);
      expect(settings.themeModeIndex, 0);
      expect(settings.currentDeckId, isNull);
    });

    test('save and reload values', () async {
      SharedPreferences.setMockInitialValues({});
      final repo = SettingsRepository();
      final target = AppSettings(
        themeModeIndex: 2,
        defaultSelectionCount: 50,
        defaultStudyMode: StudyMode.exam,
        currentDeckId: 99,
      );

      await repo.save(target);
      final loaded = await repo.load();

      expect(loaded.themeModeIndex, 2);
      expect(loaded.defaultSelectionCount, 50);
      expect(loaded.defaultStudyMode, StudyMode.exam);
      expect(loaded.currentDeckId, 99);
    });
  });
}
