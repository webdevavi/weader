import 'package:Weader/core/entities/entities.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';

abstract class WeatherForOneLocationRepository {
  Future<Either<Failure, FullWeather>> getWeather({
    @required double latitude,
    @required double longitude,
  });
}
