import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/entities/entities.dart';
import '../../../../core/error/failures.dart';
import '../entities/full_weather_list.dart';

abstract class WeatherForSavedLocationsRepository {
  Future<Either<Failure, FullWeatherList>> getWeatherForSavedLocations({
    @required List<LocationPosition> locationPositions,
  });
}
