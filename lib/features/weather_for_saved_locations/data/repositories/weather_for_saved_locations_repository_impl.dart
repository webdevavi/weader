import 'package:Weader/core/entities/entities.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/data_sources/weather_remote_data_source.dart';
import '../../../../core/entities/location_position.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/full_weather_list.dart';
import '../../domain/repositories/weather_for_saved_locations_repository.dart';

class WeatherForSavedLocationsRepositoryImpl
    implements WeatherForSavedLocationsRepository {
  final WeatherRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  WeatherForSavedLocationsRepositoryImpl({
    @required this.remoteDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, FullWeatherList>> getWeatherForSavedLocations({
    @required List<LocationPosition> locationPositions,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        List<FullWeather> _fullWeatherList = List<FullWeather>();

        await Future.forEach(locationPositions, (locationPosition) async {
          _fullWeatherList.add(
            await remoteDataSource.getWeather(
              latitude: locationPosition.latitude,
              longitude: locationPosition.longitude,
            ),
          );
        });

        return Right(FullWeatherList(fullWeatherList: _fullWeatherList));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
