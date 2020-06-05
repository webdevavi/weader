import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entity/time_aware_wallpaper.dart';
import '../repository/time_aware_wallpaper_repository.dart';

class GetWallpaper extends UseCase<TimeAwareWallpaper, Params> {
  final TimeAwareWallpaperRepository repository;

  GetWallpaper(this.repository);

  @override
  Future<Either<Failure, TimeAwareWallpaper>> call(Params params) {
    return repository.getWallpaper(params.time);
  }
}

class Params extends Equatable {
  final String time;

  Params({@required this.time});

  @override
  List<Object> get props => [time];
}
