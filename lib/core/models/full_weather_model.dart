import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import '../entities/entities.dart';
import '../util/datetime_converter.dart';
import 'models.dart';

class FullWeatherModel extends FullWeather {
  final String timezone;
  final String daytime;
  final String timezoneSpecificDaytime;
  final String sunrise;
  final String sunriseIn24;
  final String timezoneSpecificSunrise;
  final String timezoneSpecificSunriseIn24;
  final String timezoneSpecificSunset;
  final String timezoneSpecificSunsetIn24;
  final String sunset;
  final String sunsetIn24;
  final Weather current;
  final List<WeatherModel> hourly;
  final List<DailyWeatherModel> daily;

  FullWeatherModel({
    @required this.timezone,
    @required this.daytime,
    @required this.timezoneSpecificDaytime,
    @required this.sunrise,
    @required this.sunriseIn24,
    @required this.sunset,
    @required this.sunsetIn24,
    @required this.timezoneSpecificSunrise,
    @required this.timezoneSpecificSunriseIn24,
    @required this.timezoneSpecificSunset,
    @required this.timezoneSpecificSunsetIn24,
    @required this.current,
    @required this.hourly,
    @required this.daily,
  });

  factory FullWeatherModel.fromJson({
    @required Map<String, dynamic> json,
    @required DateTimeConverter dateTimeConverter,
  }) {
    WeatherModel _current;
    List<WeatherModel> _hourly = List<WeatherModel>();
    List<DailyWeatherModel> _daily = List<DailyWeatherModel>();

    String unix(timestamp) => dateTimeConverter.convertUnix(
          timestamp: timestamp,
        );

    String unix24(timestamp) => dateTimeConverter.convertUnix(
          timestamp: timestamp,
          format: Format.Hours24,
        );

    String timezone(timestamp) => dateTimeConverter.convertSpecificTimezone(
          timezone: json['timezone'],
          timestamp: timestamp,
        );

    String timezone24(timestamp) => dateTimeConverter.convertSpecificTimezone(
          timestamp: timestamp,
          timezone: json['timezone'],
          format: Format.Hours24,
        );

    String daytime(int timestamp) => dateTimeConverter.getDayTime(timestamp);

    String daytimeTZ(int timestamp) =>
        dateTimeConverter.getDaytimeTZ(timestamp, json['timezone']);

    _current = WeatherModel.fromJson(
      json: json['current'],
      dateTimeConverter: dateTimeConverter,
      timezone: json['timezone'],
    );

    json['hourly'].forEach((hourly) => _hourly.add(
          WeatherModel.fromJson(
            json: hourly,
            dateTimeConverter: dateTimeConverter,
            timezone: json['timezone'],
          ),
        ));

    json['daily'].forEach((daily) => _daily.add(
          DailyWeatherModel.fromJson(
            json: daily,
            dateTimeConverter: dateTimeConverter,
            timezone: json['timezone'],
          ),
        ));

    return FullWeatherModel(
      timezone: json['timezone'],
      daytime: daytime(json['current']['dt']),
      timezoneSpecificDaytime: daytimeTZ(json['current']['dt']),
      sunrise: unix(json['current']['sunrise']),
      sunriseIn24: unix24(json['current']['sunrise']),
      sunset: unix(json['current']['sunset']),
      sunsetIn24: unix24(json['current']['sunset']),
      timezoneSpecificSunrise: timezone(json['current']['sunrise']),
      timezoneSpecificSunriseIn24: timezone24(json['current']['sunrise']),
      timezoneSpecificSunset: timezone(json['current']['sunset']),
      timezoneSpecificSunsetIn24: timezone24(json['current']['sunset']),
      current: _current,
      hourly: _hourly,
      daily: _daily,
    );
  }
}

// For tests
// void printAll(FullWeatherModel model) {
//   print('-----------------------------');
//   print('FULL WEATHER');
//   print('-----------------------------');
//   print(model.timezone);
//   print(model.daytime);
//   print(model.sunrise);
//   print(model.sunriseIn24);
//   print(model.sunset);
//   print(model.sunsetIn24);
//   print(model.timezoneSpecificSunrise);
//   print(model.timezoneSpecificSunriseIn24);
//   print(model.timezoneSpecificSunset);
//   print(model.timezoneSpecificSunsetIn24);
//   print('-----------------------------');
//   print('CURRENT');
//   print('-----------------------------');
//   print(model.current.dateTime);
//   print(model.current.dateTimeIn24);
//   print(model.current.timezoneSpecificDateTime);
//   print(model.current.timezoneSpecificDateTimeIn24);
//   print(model.current.temperature);
//   print(model.current.temperatureAsF);
//   print(model.current.feelsLikeTemperature);
//   print(model.current.feelsLikeTemperatureAsF);
//   print(model.current.windSpeed);
//   print(model.current.windSpeedInMPH);
//   print(model.current.description);
//   print(model.current.icon);
//   print(model.current.day);
//   print(model.current.timezoneSpecificDay);
//   print(model.current.temperatureIcon);
//   print('-----------------------------');
//   print('HOURLY');
//   print('-----------------------------');
//   print(model.hourly[0].dateTime);
//   print(model.hourly[0].dateTimeIn24);
//   print(model.hourly[0].timezoneSpecificDateTime);
//   print(model.hourly[0].timezoneSpecificDateTimeIn24);
//   print(model.hourly[0].temperature);
//   print(model.hourly[0].temperatureAsF);
//   print(model.hourly[0].feelsLikeTemperature);
//   print(model.hourly[0].feelsLikeTemperatureAsF);
//   print(model.hourly[0].windSpeed);
//   print(model.hourly[0].windSpeedInMPH);
//   print(model.hourly[0].description);
//   print(model.hourly[0].icon);
//   print(model.hourly[0].temperatureIcon);
//   print(model.hourly[0].day);
//   print(model.hourly[0].timezoneSpecificDay);
//   print('-----------------------------');
//   print('DAILY');
//   print('-----------------------------');
//   print(model.daily[0].sunrise);
//   print(model.daily[0].sunriseIn24);
//   print(model.daily[0].timezoneSpecificSunrise);
//   print(model.daily[0].timezoneSpecificSunriseIn24);
//   print(model.daily[0].sunset);
//   print(model.daily[0].sunsetIn24);
//   print(model.daily[0].timezoneSpecificSunset);
//   print(model.daily[0].timezoneSpecificSunsetIn24);
//   print(model.daily[0].dayTemperature);
//   print(model.daily[0].dayTemperatureAsF);
//   print(model.daily[0].nightTemperature);
//   print(model.daily[0].nightTemperatureAsF);
//   print(model.daily[0].eveTemperature);
//   print(model.daily[0].eveTemperatureAsF);
//   print(model.daily[0].mornTemperature);
//   print(model.daily[0].mornTemperatureAsF);
//   print(model.daily[0].minTemperature);
//   print(model.daily[0].minTemperatureAsF);
//   print(model.daily[0].maxTemperature);
//   print(model.daily[0].maxTemperatureAsF);
//   print(model.daily[0].dayFeelsLikeTemperature);
//   print(model.daily[0].dayFeelsLikeTemperatureAsF);
//   print(model.daily[0].nightFeelsLikeTemperature);
//   print(model.daily[0].nightFeelsLikeTemperatureAsF);
//   print(model.daily[0].eveFeelsLikeTemperature);
//   print(model.daily[0].eveFeelsLikeTemperatureAsF);
//   print(model.daily[0].mornFeelsLikeTemperature);
//   print(model.daily[0].mornFeelsLikeTemperatureAsF);
//   print(model.daily[0].windSpeed);
//   print(model.daily[0].windSpeedInMPH);
//   print(model.daily[0].description);
//   print(model.daily[0].icon);
//   print(model.daily[0].dateTime);
//   print(model.daily[0].timezoneSpecificDateTime);
//   print(model.daily[0].temperatureIconDay);
//   print(model.daily[0].temperatureIconEve);
//   print(model.daily[0].temperatureIconMax);
//   print(model.daily[0].temperatureIconMin);
//   print(model.daily[0].temperatureIconMorn);
//   print(model.daily[0].temperatureIconNight);
// }
