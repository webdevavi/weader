import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weader/core/error/exception.dart';
import 'package:weader/core/settings/initial_settings.dart';
import 'package:weader/features/settings/data/data_sources/settings_local_data_source.dart';
import 'package:weader/features/settings/data/models/settings_model.dart';
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  SettingsLocalDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = SettingsLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  final tSettingsModel = SettingsModel.fromJson(
    json.decode(
      fixture('settings.json'),
    ),
  );

  group(
    'getSettings',
    () {
      test(
        'should return Settings from SharedPreferences if there is one',
        () async {
          // arrange
          when(mockSharedPreferences.getString(any)).thenReturn(
            fixture('settings.json'),
          );
          // act
          final result = await dataSource.getSettings();
          // assert
          verify(mockSharedPreferences.getString(SETTINGS));
          expect(result, equals(tSettingsModel));
        },
      );

      test(
        'should return InitialSettings when there is no settings data',
        () async {
          // arrange
          when(mockSharedPreferences.getString(any)).thenReturn(null);
          // act
          final result = await dataSource.getSettings();
          // assert
          expect(result, equals(initialSettings));
        },
      );

      test(
        'should throw [UnexpectedException] for any exception',
        () async {
          // arrange
          when(mockSharedPreferences.getString(any)).thenThrow(
            PlatformException(
              code: "101",
            ),
          );
          // act
          final call = dataSource.getSettings;
          // assert
          expect(() => call(), throwsA(TypeMatcher<UnexpectedException>()));
        },
      );
    },
  );

  group(
    'setSettings',
    () {
      test(
        'should call SharedPrefrences to save settings',
        () async {
          // act
          dataSource.setSettings(tSettingsModel);
          // assert
          final expectedJsonString = json.encode(tSettingsModel);
          verify(mockSharedPreferences.setString(
            SETTINGS,
            expectedJsonString,
          ));
        },
      );

      test(
        'should return the saved settings',
        () async {
          // act
          final result = await dataSource.setSettings(tSettingsModel);
          // assert
          expect(result, equals(tSettingsModel));
        },
      );

      test(
        'should throw [UnexpectedException] for any exception',
        () async {
          // arrange
          when(mockSharedPreferences.setString(any, any)).thenThrow(
            PlatformException(
              code: "101",
            ),
          );
          // act
          final call = dataSource.setSettings;
          // assert
          expect(
            () => call(tSettingsModel),
            throwsA(TypeMatcher<UnexpectedException>()),
          );
        },
      );
    },
  );
}
