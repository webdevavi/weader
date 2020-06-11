import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class WeatherForOneLocationEvent extends Equatable {
  WeatherForOneLocationEvent();
}

class GetWeatherForOneLocationEvent extends WeatherForOneLocationEvent {
  final double latitude;
  final double longitude;

  GetWeatherForOneLocationEvent({
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
