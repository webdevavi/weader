import 'package:weader/core/error/exception.dart';
import 'package:weader/core/error/failures.dart';
import 'package:weader/core/entities/settings.dart';
import 'package:dartz/dartz.dart';
import 'package:weader/features/settings/data/data_sources/settings_local_data_source.dart';
import 'package:weader/features/settings/data/models/settings_model.dart';
import 'package:weader/features/settings/domain/repository/settings_repository.dart';

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
  Future<Either<Failure, Settings>> setSettings(SettingsModel settings) async {
    try {
      final newSettings = await localDataSource.setSettings(settings);
      return Right(newSettings);
    } on UnexpectedException {
      return Left(UnexpectedFailure());
    }
  }
}
