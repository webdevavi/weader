import 'package:dartz/dartz.dart';
import 'package:weader/core/entities/settings.dart';
import 'package:weader/core/error/failures.dart';
import 'package:weader/features/settings/data/models/settings_model.dart';

abstract class SettingsRepository {
  Future<Either<Failure, Settings>> getSettings();
  Future<Either<Failure, Settings>> setSettings(SettingsModel settings);
}
