import 'package:dartz/dartz.dart';

import '../../../../core/entities/settings.dart';
import '../../../../core/error/failures.dart';

abstract class SettingsRepository {
  Future<Either<Failure, Settings>> getSettings();
  Future<Either<Failure, Settings>> switchUnitSystem(UnitSystem unitSystem);
  Future<Either<Failure, Settings>> switchDataPreference(
    DataPreference dataPreference,
  );
  Future<Either<Failure, Settings>> switchTimeFormat(TimeFormat timeFormat);
  Future<Either<Failure, Settings>> switchCurrentTheme(
    CurrentTheme currentTheme,
  );
  Future<Either<Failure, Settings>> switchWallpaper(Wallpaper wallpaper);
}
