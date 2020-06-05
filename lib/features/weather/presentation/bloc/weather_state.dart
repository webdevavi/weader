import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:weader/features/weather/domain/entities/full_weather.dart';

@immutable
abstract class WeatherState extends Equatable {
  WeatherState();
}

class WeatherEmpty extends WeatherState {
  @override
  List<Object> get props => [];
}

class WeatherLoading extends WeatherState {
  @override
  List<Object> get props => [];
}

class WeatherLoaded extends WeatherState {
  final FullWeather weather;

  WeatherLoaded({@required this.weather});
  @override
  List<Object> get props => [weather];
}

class WeatherError extends WeatherState {
  final String message;

  WeatherError({@required this.message});
  @override
  List<Object> get props => [message];
}
