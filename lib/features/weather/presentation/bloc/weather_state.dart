import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:weader/features/weather/domain/entities/full_weather.dart';

@immutable
abstract class WeatherState extends Equatable {
  WeatherState();
}

class Empty extends WeatherState {
  @override
  List<Object> get props => [];
}

class Loading extends WeatherState {
  @override
  List<Object> get props => [];
}

class Loaded extends WeatherState {
  final FullWeather weather;

  Loaded({@required this.weather});
  @override
  List<Object> get props => [weather];
}

class Error extends WeatherState {
  final String message;

  Error({@required this.message});
  @override
  List<Object> get props => [message];
}
