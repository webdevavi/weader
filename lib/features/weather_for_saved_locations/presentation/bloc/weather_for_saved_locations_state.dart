import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/full_weather_list.dart';

@immutable
abstract class WeatherForSavedLocationsState extends Equatable {
  WeatherForSavedLocationsState();
}

class WeatherForSavedLocationsEmpty extends WeatherForSavedLocationsState {
  @override
  List<Object> get props => [];
}

class WeatherForSavedLocationsLoading extends WeatherForSavedLocationsState {
  @override
  List<Object> get props => [];
}

class WeatherForSavedLocationsLoaded extends WeatherForSavedLocationsState {
  final FullWeatherList fullWeatherList;

  WeatherForSavedLocationsLoaded({@required this.fullWeatherList});
  @override
  List<Object> get props => [fullWeatherList];
}

class WeatherForSavedLocationsError extends WeatherForSavedLocationsState {
  final String message;

  WeatherForSavedLocationsError({@required this.message});
  @override
  List<Object> get props => [message];
}
