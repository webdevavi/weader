import 'package:dartz/dartz.dart';

import '../../../../core/entities/settings.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repository/settings_repository.dart';
import '../data_sources/settings_local_data_source.dart';
import '../models/settings_model.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl(this.localDataSource);
  @override
  Future<Either<Failure, Settings>> getSettings() async {
    try {
      final initialSettings = await localDataSource.getSettings();
      return Right(initialSettings);
    } on NoLocalDataException {
      return Left(NoLocalDataFailure());
    }
  }

  @override
  Future<Either<Failure, Settings>> switchCurrentTheme(
    CurrentTheme currentTheme,
  ) async {
    try {
      final oldSettings = await localDataSource.getSettings();
      final newSettings = SettingsModel(
        unitSystem: oldSettings.unitSystem,
        timeFormat: oldSettings.timeFormat,
        dataPreference: oldSettings.dataPreference,
        currentTheme: currentTheme,
        wallpaper: oldSettings.wallpaper,
      );
      return _setSetting(newSettings);
    } on UnexpectedException {
      return Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Settings>> switchDataPreference(
    DataPreference dataPreference,
  ) async {
    try {
      final oldSettings = await localDataSource.getSettings();
      final newSettings = SettingsModel(
        unitSystem: oldSettings.unitSystem,
        timeFormat: oldSettings.timeFormat,
        dataPreference: dataPreference,
        currentTheme: oldSettings.currentTheme,
        wallpaper: oldSettings.wallpaper,
      );
      return _setSetting(newSettings);
    } on UnexpectedException {
      return Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Settings>> switchTimeFormat(
      TimeFormat timeFormat) async {
    try {
      final oldSettings = await localDataSource.getSettings();
      final newSettings = SettingsModel(
        unitSystem: oldSettings.unitSystem,
        timeFormat: timeFormat,
        dataPreference: oldSettings.dataPreference,
        currentTheme: oldSettings.currentTheme,
        wallpaper: oldSettings.wallpaper,
      );
      return _setSetting(newSettings);
    } on UnexpectedException {
      return Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Settings>> switchUnitSystem(
      UnitSystem unitSystem) async {
    try {
      final oldSettings = await localDataSource.getSettings();
      final newSettings = SettingsModel(
        unitSystem: unitSystem,
        timeFormat: oldSettings.timeFormat,
        dataPreference: oldSettings.dataPreference,
        currentTheme: oldSettings.currentTheme,
        wallpaper: oldSettings.wallpaper,
      );
      return _setSetting(newSettings);
    } on UnexpectedException {
      return Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Settings>> switchWallpaper(Wallpaper wallpaper) async {
    try {
      final oldSettings = await localDataSource.getSettings();
      final newSettings = SettingsModel(
        unitSystem: oldSettings.unitSystem,
        timeFormat: oldSettings.timeFormat,
        dataPreference: oldSettings.dataPreference,
        currentTheme: oldSettings.currentTheme,
        wallpaper: wallpaper,
      );
      return _setSetting(newSettings);
    } on UnexpectedException {
      return Left(UnexpectedFailure());
    }
  }

  Future<Either<Failure, Settings>> _setSetting(
      SettingsModel newSettings) async {
    try {
      await localDataSource.setSettings(newSettings);
      return Right(newSettings);
    } on UnexpectedException {
      return Left(UnexpectedFailure());
    }
  }
}
