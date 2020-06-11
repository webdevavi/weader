import 'package:Weader/core/entities/entities.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/weather_for_one_location_repository.dart';

class GetWeatherForOneLocation
    extends UseCase<FullWeather, GetWeatherForOneLocationParams> {
  final WeatherForOneLocationRepository repository;

  GetWeatherForOneLocation(this.repository);

  @override
  Future<Either<Failure, FullWeather>> call(
      GetWeatherForOneLocationParams params) async {
    return await repository.getWeather(
        latitude: params.latitude, longitude: params.longitude);
  }
}

class GetWeatherForOneLocationParams extends Equatable {
  final double latitude;
  final double longitude;

  GetWeatherForOneLocationParams({
    @required this.latitude,
    @required this.longitude,
  });

  @override
  List<Object> get props => [
        latitude,
        longitude,
      ];
}
