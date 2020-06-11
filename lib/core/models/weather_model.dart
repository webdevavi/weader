import 'package:meta/meta.dart';

import '../entities/entities.dart';
import '../util/datetime_converter.dart';

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

  factory WeatherModel.fromJson({
    @required Map<String, dynamic> json,
    @required DateTimeConverter dateTimeConverter,
    @required String timezone,
  }) {
    String unix(timestamp) => dateTimeConverter.convertUnix(
          timestamp: timestamp,
        );

    String tz(timestamp) => dateTimeConverter.convertSpecificTimezone(
          timezone: timezone,
          timestamp: timestamp,
        );

    String unix24(timestamp) => dateTimeConverter.convertUnix(
          timestamp: timestamp,
          format: Format.Hours24,
        );
    String timezone24(timestamp) => dateTimeConverter.convertSpecificTimezone(
          timestamp: timestamp,
          timezone: timezone,
          format: Format.Hours24,
        );

    String day(timestamp) => dateTimeConverter.convertUnixToDay(timestamp);
    String tzDay(timestamp) => dateTimeConverter.convertSpecificTimezoneToDay(
          timestamp,
          timezone,
        );

    int asInt(num item) => item.toInt();

    String asC(num temp) => asInt(temp).toString() + '°C';

    String asF(num temp) =>
        ((asInt(temp) * 9 / 5) + 32).toInt().toString() + '°F';

    String asMPS(num speed) => speed.toStringAsFixed(1) + ' mps';

    String asMPH(num speed) => (speed * 2.237).toStringAsFixed(1) + ' mph';

    String tempIcon(int temp) {
      if (temp > 40) return 'high';
      if (temp < 20) return 'low';
      return 'mid';
    }

    return WeatherModel(
      dateTime: unix(json['dt']),
      dateTimeIn24: unix24(json['dt']),
      timezoneSpecificDateTime: tz(json['dt']),
      timezoneSpecificDateTimeIn24: timezone24(json['dt']),
      temperature: asC(json['temp']),
      temperatureAsF: asF(json['temp']),
      feelsLikeTemperature: asC(json['feels_like']),
      feelsLikeTemperatureAsF: asF(json['feels_like']),
      windSpeed: asMPS(json['wind_speed']),
      windSpeedInMPH: asMPH(json['wind_speed']),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
      day: day(json['dt']),
      timezoneSpecificDay: tzDay(json['dt']),
      temperatureIcon: tempIcon(asInt(json['temp'])),
    );
  }
}
