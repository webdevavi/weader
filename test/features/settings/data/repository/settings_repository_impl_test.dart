import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weader/core/entities/settings.dart';
import 'package:weader/core/error/exception.dart';
import 'package:weader/core/error/failures.dart';
import 'package:weader/features/settings/data/data_sources/settings_local_data_source.dart';
import 'package:weader/features/settings/data/models/settings_model.dart';
import 'package:weader/features/settings/data/repository/settings_repository_impl.dart';

class MockLocalDataSource extends Mock implements SettingsLocalDataSource {}

void main() {
  SettingsRepositoryImpl repository;
  MockLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockLocalDataSource();
    repository = SettingsRepositoryImpl(mockLocalDataSource);
  });
  final tSettingsModel = SettingsModel(
    unitSystem: UnitSystem(
      isImperial: false,
    ),
    timeFormat: TimeFormat(
      is24Hours: false,
    ),
    dataPreference: DataPreference(
      isLocal: true,
    ),
    currentTheme: CurrentTheme(
      isDark: false,
    ),
    wallpaper: Wallpaper(
      isTimeAware: true,
    ),
  );

  test(
    'should return cached Settings data',
    () async {
      // arrange
      when(mockLocalDataSource.getSettings())
          .thenAnswer((_) async => tSettingsModel);
      // act
      final result = await repository.getSettings();
      // assert
      verify(mockLocalDataSource.getSettings());
      expect(result, Right(tSettingsModel));
    },
  );

  test(
    'should return NoLocalDataFailure when there is no cached settings data present',
    () async {
      // arrange
      when(mockLocalDataSource.getSettings()).thenThrow(NoLocalDataException());
      // act
      final result = await repository.getSettings();
      // assert
      verify(mockLocalDataSource.getSettings());
      expect(result, equals(Left(NoLocalDataFailure())));
    },
  );
}
