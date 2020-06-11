import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/entities/entities.dart';

@immutable
abstract class WeatherForSavedLocationsEvent extends Equatable {
  WeatherForSavedLocationsEvent();
}

class GetWeatherForSavedLocationsEvent extends WeatherForSavedLocationsEvent {
  final List<LocationPosition> locationPositions;

  GetWeatherForSavedLocationsEvent(this.locationPositions);

  @override
  List<Object> get props => [locationPositions];
}
