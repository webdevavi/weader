import 'package:Weader/core/entities/entities.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/data_sources/weather_remote_data_source.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/weather_for_one_location_repository.dart';

class WeatherForOneLocationRepositoryImpl
    implements WeatherForOneLocationRepository {
  final WeatherRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  WeatherForOneLocationRepositoryImpl({
    @required this.remoteDataSource,
    @required this.networkInfo,
  });
  @override
  Future<Either<Failure, FullWeather>> getWeather({
    @required double latitude,
    @required double longitude,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteWeather = await remoteDataSource.getWeather(
          latitude: latitude,
          longitude: longitude,
        );
        return Right(remoteWeather);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
