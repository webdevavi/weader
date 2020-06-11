import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/entities/entities.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/full_weather_list.dart';
import '../repositories/weather_for_saved_locations_repository.dart';

class GetWeatherForSavedLocations
    extends UseCase<FullWeatherList, GetWeatherForSavedLocationsParams> {
  final WeatherForSavedLocationsRepository repository;

  GetWeatherForSavedLocations(this.repository);

  @override
  Future<Either<Failure, FullWeatherList>> call(
      GetWeatherForSavedLocationsParams params) async {
    return await repository.getWeatherForSavedLocations(
      locationPositions: params.locationPositions,
    );
  }
}

class GetWeatherForSavedLocationsParams extends Equatable {
  final List<LocationPosition> locationPositions;

  GetWeatherForSavedLocationsParams(this.locationPositions);

  @override
  List<Object> get props => [locationPositions];
}
