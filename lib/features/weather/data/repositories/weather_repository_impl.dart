import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:weader/core/error/exception.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/weather_entities.dart';
import '../../domain/repositories/weather_repository.dart';
import '../data_sources/weather_remote_data_source.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  WeatherRepositoryImpl({
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
