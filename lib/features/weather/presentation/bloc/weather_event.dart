import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class WeatherEvent extends Equatable {
  WeatherEvent();
}

class GetWeatherEvent extends WeatherEvent {
  final double latitude;
  final double longitude;

  GetWeatherEvent({
    @required this.latitude,
    @required this.longitude,
  });
  @override
  List<Object> get props {
    return [
      latitude,
      longitude,
    ];
  }
}
