import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Weather extends Equatable {
  final String dateTime;
  final String dateTimeIn24;
  final String timezoneSpecificDateTime;
  final String timezoneSpecificDateTimeIn24;
  final String temperature;
  final String temperatureAsF;
  final String feelsLikeTemperature;
  final String feelsLikeTemperatureAsF;
  final String windSpeed;
  final String windSpeedInMPH;
  final String description;
  final String icon;
  final String day;
  final String timezoneSpecificDay;
  final String temperatureIcon;

  Weather({
    @required this.dateTime,
    @required this.dateTimeIn24,
    @required this.timezoneSpecificDateTime,
    @required this.timezoneSpecificDateTimeIn24,
    @required this.temperature,
    @required this.temperatureAsF,
    @required this.feelsLikeTemperature,
    @required this.feelsLikeTemperatureAsF,
    @required this.windSpeed,
    @required this.windSpeedInMPH,
    @required this.description,
    @required this.icon,
    @required this.day,
    @required this.timezoneSpecificDay,
    @required this.temperatureIcon,
  });
  @override
  List<Object> get props => [
        dateTime,
        dateTimeIn24,
        timezoneSpecificDateTime,
        timezoneSpecificDateTimeIn24,
        temperature,
        temperatureAsF,
        feelsLikeTemperature,
        feelsLikeTemperatureAsF,
        windSpeed,
        windSpeedInMPH,
        description,
        icon,
        day,
        timezoneSpecificDay,
        temperatureIcon,
      ];
}
