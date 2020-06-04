import 'package:meta/meta.dart';

import '../../domain/entities/weather_entities.dart';

class WeatherModel extends Weather {
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
  final String temperatureIcon;
  final String day;
  final String timezoneSpecificDay;

  WeatherModel({
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
    @required this.temperatureIcon,
    @required this.day,
    @required this.timezoneSpecificDay,
  });
}
