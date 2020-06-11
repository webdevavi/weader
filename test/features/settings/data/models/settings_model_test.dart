import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:Weader/core/entities/settings.dart';
import 'package:Weader/features/settings/data/models/settings_model.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tSettingsModel = SettingsModel(
    unitSystem: UnitSystem(
      isImperial: false,
    ),
    timeFormat: TimeFormat(
      is24Hours: false,
    ),
    dataPreference: DataPreference(
      isLocal: false,
    ),
    currentTheme: CurrentTheme(
      isDark: false,
    ),
    wallpaper: Wallpaper(
      isTimeAware: true,
    ),
  );

  test(
    'should be a subclass of Settings entity',
    () async {
      // assert
      expect(tSettingsModel, isA<Settings>());
    },
  );

  group(
    'SettingsModel.fromJson',
    () {
      test(
        'should return a valid model',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap = json.decode(
            fixture('settings.json'),
          );
          // act
          final result = SettingsModel.fromJson(jsonMap);
          // assert
          expect(result, tSettingsModel);
        },
      );
    },
  );

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // act
        final result = tSettingsModel.toJson();
        // assert
        final expectedJsonMap = {
          "unit_system_is_imperial": false,
          "time_format_is_24_hours": false,
          "data_preference_is_local": false,
          "current_theme_is_dark": false,
          "wallpaper_is_time_aware": true
        };
        expect(result, expectedJsonMap);
      },
    );
  });
}
