import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../entities/weather_entities.dart';

abstract class WeatherRepository {
  Future<Either<Failure, FullWeather>> getWeather({
    @required double latitude,
    @required double longitude,
  });
}
