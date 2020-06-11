import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:Weader/core/entities/settings.dart';
import 'package:Weader/core/error/exception.dart';
import 'package:Weader/core/error/failures.dart';
import 'package:Weader/features/settings/data/data_sources/settings_local_data_source.dart';
import 'package:Weader/features/settings/data/models/settings_model.dart';
import 'package:Weader/features/settings/data/repository/settings_repository_impl.dart';

class MockLocalDataSource extends Mock implements SettingsLocalDataSource {}

void main() {
  SettingsRepositoryImpl repository;
  MockLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockLocalDataSource();
    repository = SettingsRepositoryImpl(mockLocalDataSource);
  });
  final tSettingsModel = SettingsModel(
    unitSystem: UnitSystem(isImperial: false),
    timeFormat: TimeFormat(is24Hours: false),
    dataPreference: DataPreference(isLocal: false),
    currentTheme: CurrentTheme(isDark: false),
    wallpaper: Wallpaper(isTimeAware: false),
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

  void doTests({
    tNewSettingsModel,
    Future<Either<Failure, Settings>> function(),
  }) {
    final Settings tNewSettings = tNewSettingsModel;
    test(
      'should return new settings ',
      () async {
        // arrange
        when(mockLocalDataSource.getSettings())
            .thenAnswer((_) async => tSettingsModel);
        // act
        final result = await function();
        // assert
        verify(mockLocalDataSource.getSettings());
        verify(mockLocalDataSource.setSettings(tNewSettingsModel));
        expect(result, Right(tNewSettings));
      },
    );

    test(
      'should return UnexpectedFailure when getting data fails with UnexpectedException',
      () async {
        when(mockLocalDataSource.getSettings())
            .thenThrow(UnexpectedException());
        // act
        final result = await function();
        // assert
        expect(result, Left(UnexpectedFailure()));
      },
    );

    test(
      'should return UnexpectedFailure when setting data fails with UnexpectedException',
      () async {
        when(mockLocalDataSource.getSettings())
            .thenAnswer((_) async => tSettingsModel);
        when(mockLocalDataSource.setSettings(any))
            .thenThrow(UnexpectedException());
        // act
        final result = await function();
        // assert
        expect(result, Left(UnexpectedFailure()));
      },
    );
  }

  group('switchUnitSystem', () {
    final tUnitSystem = UnitSystem(isImperial: true);

    final tNewSettingsModel = SettingsModel(
      unitSystem: UnitSystem(isImperial: true),
      timeFormat: TimeFormat(is24Hours: false),
      dataPreference: DataPreference(isLocal: false),
      currentTheme: CurrentTheme(isDark: false),
      wallpaper: Wallpaper(isTimeAware: false),
    );

    doTests(
      function: () => repository.switchUnitSystem(tUnitSystem),
      tNewSettingsModel: tNewSettingsModel,
    );
  });

  group('switchTimeFormat', () {
    final tTimeFormat = TimeFormat(is24Hours: true);

    final tNewSettingsModel = SettingsModel(
      unitSystem: UnitSystem(isImperial: false),
      timeFormat: TimeFormat(is24Hours: true),
      dataPreference: DataPreference(isLocal: false),
      currentTheme: CurrentTheme(isDark: false),
      wallpaper: Wallpaper(isTimeAware: false),
    );

    doTests(
      function: () => repository.switchTimeFormat(tTimeFormat),
      tNewSettingsModel: tNewSettingsModel,
    );
  });

  group('switchDataPreference', () {
    final tDataPreference = DataPreference(isLocal: true);

    final tNewSettingsModel = SettingsModel(
      unitSystem: UnitSystem(isImperial: false),
      timeFormat: TimeFormat(is24Hours: false),
      dataPreference: DataPreference(isLocal: true),
      currentTheme: CurrentTheme(isDark: false),
      wallpaper: Wallpaper(isTimeAware: false),
    );

    doTests(
      function: () => repository.switchDataPreference(tDataPreference),
      tNewSettingsModel: tNewSettingsModel,
    );
  });

  group('switchCurrentTheme', () {
    final tCurrentTheme = CurrentTheme(isDark: true);

    final tNewSettingsModel = SettingsModel(
      unitSystem: UnitSystem(isImperial: false),
      timeFormat: TimeFormat(is24Hours: false),
      dataPreference: DataPreference(isLocal: false),
      currentTheme: CurrentTheme(isDark: true),
      wallpaper: Wallpaper(isTimeAware: false),
    );

    doTests(
      function: () => repository.switchCurrentTheme(tCurrentTheme),
      tNewSettingsModel: tNewSettingsModel,
    );
  });

  group('switchWallpaper', () {
    final tWallpaper = Wallpaper(isTimeAware: true);

    final tNewSettingsModel = SettingsModel(
      unitSystem: UnitSystem(isImperial: false),
      timeFormat: TimeFormat(is24Hours: false),
      dataPreference: DataPreference(isLocal: false),
      currentTheme: CurrentTheme(isDark: false),
      wallpaper: Wallpaper(isTimeAware: true),
    );

    doTests(
      function: () => repository.switchWallpaper(tWallpaper),
      tNewSettingsModel: tNewSettingsModel,
    );
  });
}
