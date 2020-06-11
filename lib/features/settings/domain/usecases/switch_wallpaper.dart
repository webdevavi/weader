import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/entities/entities.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/settings_repository.dart';

class SwitchWallpaper extends UseCase<Settings, SwitchWallpaperParams> {
  final SettingsRepository repository;

  SwitchWallpaper(this.repository);

  @override
  Future<Either<Failure, Settings>> call(SwitchWallpaperParams params) async {
    return await repository.switchWallpaper(params.wallpaper);
  }
}

class SwitchWallpaperParams extends Equatable {
  final Wallpaper wallpaper;

  SwitchWallpaperParams(this.wallpaper);
  @override
  List<Object> get props => [wallpaper];
}
