import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/entities/entities.dart';

@immutable
abstract class WeatherForOneLocationState extends Equatable {
  WeatherForOneLocationState();
}

class WeatherForOneLocationEmpty extends WeatherForOneLocationState {
  @override
  List<Object> get props => [];
}

class WeatherForOneLocationLoading extends WeatherForOneLocationState {
  @override
  List<Object> get props => [];
}

class WeatherForOneLocationLoaded extends WeatherForOneLocationState {
  final FullWeather weather;

  WeatherForOneLocationLoaded({@required this.weather});
  @override
  List<Object> get props => [weather];
}

class WeatherForOneLocationError extends WeatherForOneLocationState {
  final String message;

  WeatherForOneLocationError({@required this.message});
  @override
  List<Object> get props => [message];
}
