import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:weader/core/error/exception.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entity/time_aware_wallpaper.dart';
import '../../domain/repository/time_aware_wallpaper_repository.dart';
import '../datasources/time_aware_wallpaper_remote_data_source.dart';

class TimeAwareWallpaperRepositoryImpl implements TimeAwareWallpaperRepository {
  final TimeAwareWallpaperRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  TimeAwareWallpaperRepositoryImpl({
    @required this.remoteDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, TimeAwareWallpaper>> getWallpaper(String time) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getWallpaper(time);
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }
}
