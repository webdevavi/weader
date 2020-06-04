import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:timezone/timezone.dart';
import 'package:weader/core/util/datetime_converter.dart';
import 'package:weader/core/util/unit_converter.dart';

import './weather_models.dart';
import '../../domain/entities/weather_entities.dart';

class FullWeatherModel extends FullWeather {
  final String timezone;
  final String daytime;
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

  factory FullWeatherModel.fromJson(Map<String, dynamic> json) {
    List<WeatherModel> _hourly = List<WeatherModel>();
    List<DailyWeatherModel> _daily = List<DailyWeatherModel>();

    DateTimeConverter dtc = DateTimeConverter();
    UnitConverter uc = UnitConverter();

    String unix(timestamp) => dtc.convertUnix(
          timestamp: timestamp,
        );
    String unixWWD(timestamp) => dtc.convertUnix(
          timestamp: timestamp,
          format: Format.WeekdayWithDate,
        );
    String timezone(timestamp) => dtc.convertSpecificTimezone(
          timezone: json['timezone'],
          timestamp: timestamp,
        );
    String timezoneWWD(timestamp) => dtc.convertSpecificTimezone(
          timezone: json['timezone'],
          timestamp: timestamp,
          format: Format.WeekdayWithDate,
        );
    String unix24(timestamp) => dtc.convertUnix(
          timestamp: timestamp,
          format: Format.Hours24,
        );
    String timezone24(timestamp) => dtc.convertSpecificTimezone(
          timestamp: timestamp,
          timezone: json['timezone'],
          format: Format.Hours24,
        );

    String day(timestamp) => dtc.convertUnixToDay(timestamp);
    String tzDay(timestamp) => dtc.convertSpecificTimezoneToDay(
          timestamp,
          json['timezone'],
        );

    int asInt(num item) => item.toInt();

    String asC(num temp) => asInt(temp).toString() + '°C';

    String asF(num temp) => uc.convertToF(asInt(temp)).toString() + '°F';

    String asMPS(num speed) => speed.toStringAsFixed(1) + ' mps';

    String asMPH(num speed) => (speed * 2.237).toStringAsFixed(1) + ' mph';

    String tempIcon(int temp) {
      if (temp > 40) return 'high';
      if (temp < 20) return 'low';
      return 'mid';
    }

    String getDayTime(int timestamp) {
      final DateTime _dateTime = dtc.convertUnixToHuman(timestamp);

      //4:00 - 7:30 sunrise
      if (_dateTime.isAfter(DateTime(
              _dateTime.year, _dateTime.month, _dateTime.day, 4, 00)) &&
          _dateTime.isBefore(
              DateTime(_dateTime.year, _dateTime.month, _dateTime.day, 7, 30)))
        return 'sunrise';

      //7:30 - 12:00 morning
      if (_dateTime.isAfter(DateTime(
              _dateTime.year, _dateTime.month, _dateTime.day, 7, 30)) &&
          _dateTime.isBefore(
              DateTime(_dateTime.year, _dateTime.month, _dateTime.day, 12, 00)))
        return 'morning';
      //12:00 - 16:00 afternoon
      if (_dateTime.isAfter(DateTime(
              _dateTime.year, _dateTime.month, _dateTime.day, 12, 00)) &&
          _dateTime.isBefore(
              DateTime(_dateTime.year, _dateTime.month, _dateTime.day, 16, 00)))
        return 'afternoon';

      //16:00 - 18:00 evening
      if (_dateTime.isAfter(DateTime(
              _dateTime.year, _dateTime.month, _dateTime.day, 16, 00)) &&
          _dateTime.isBefore(
              DateTime(_dateTime.year, _dateTime.month, _dateTime.day, 18, 00)))
        return 'evening';

      //18:00 - 19:00 sunset
      if (_dateTime.isAfter(DateTime(
              _dateTime.year, _dateTime.month, _dateTime.day, 18, 00)) &&
          _dateTime.isBefore(
              DateTime(_dateTime.year, _dateTime.month, _dateTime.day, 19, 00)))
        return 'sunset';

      //7 AM - 4AM night
      return 'night';
    }

    // For tests
    void printAll(FullWeatherModel model) {
      print('-----------------------------');
      print('FULL WEATHER');
      print('-----------------------------');
      print(model.timezone);
      print(model.daytime);
      print(model.sunrise);
      print(model.sunriseIn24);
      print(model.sunset);
      print(model.sunsetIn24);
      print(model.timezoneSpecificSunrise);
      print(model.timezoneSpecificSunriseIn24);
      print(model.timezoneSpecificSunset);
      print(model.timezoneSpecificSunsetIn24);
      print('-----------------------------');
      print('CURRENT');
      print('-----------------------------');
      print(model.current.dateTime);
      print(model.current.dateTimeIn24);
      print(model.current.timezoneSpecificDateTime);
      print(model.current.timezoneSpecificDateTimeIn24);
      print(model.current.temperature);
      print(model.current.temperatureAsF);
      print(model.current.feelsLikeTemperature);
      print(model.current.feelsLikeTemperatureAsF);
      print(model.current.windSpeed);
      print(model.current.windSpeedInMPH);
      print(model.current.description);
      print(model.current.icon);
      print(model.current.day);
      print(model.current.timezoneSpecificDay);
      print(model.current.temperatureIcon);
      print('-----------------------------');
      print('HOURLY');
      print('-----------------------------');
      print(model.hourly[0].dateTime);
      print(model.hourly[0].dateTimeIn24);
      print(model.hourly[0].timezoneSpecificDateTime);
      print(model.hourly[0].timezoneSpecificDateTimeIn24);
      print(model.hourly[0].temperature);
      print(model.hourly[0].temperatureAsF);
      print(model.hourly[0].feelsLikeTemperature);
      print(model.hourly[0].feelsLikeTemperatureAsF);
      print(model.hourly[0].windSpeed);
      print(model.hourly[0].windSpeedInMPH);
      print(model.hourly[0].description);
      print(model.hourly[0].icon);
      print(model.hourly[0].temperatureIcon);
      print(model.hourly[0].day);
      print(model.hourly[0].timezoneSpecificDay);
      print('-----------------------------');
      print('DAILY');
      print('-----------------------------');
      print(model.daily[0].sunrise);
      print(model.daily[0].sunriseIn24);
      print(model.daily[0].timezoneSpecificSunrise);
      print(model.daily[0].timezoneSpecificSunriseIn24);
      print(model.daily[0].sunset);
      print(model.daily[0].sunsetIn24);
      print(model.daily[0].timezoneSpecificSunset);
      print(model.daily[0].timezoneSpecificSunsetIn24);
      print(model.daily[0].dayTemperature);
      print(model.daily[0].dayTemperatureAsF);
      print(model.daily[0].nightTemperature);
      print(model.daily[0].nightTemperatureAsF);
      print(model.daily[0].eveTemperature);
      print(model.daily[0].eveTemperatureAsF);
      print(model.daily[0].mornTemperature);
      print(model.daily[0].mornTemperatureAsF);
      print(model.daily[0].minTemperature);
      print(model.daily[0].minTemperatureAsF);
      print(model.daily[0].maxTemperature);
      print(model.daily[0].maxTemperatureAsF);
      print(model.daily[0].dayFeelsLikeTemperature);
      print(model.daily[0].dayFeelsLikeTemperatureAsF);
      print(model.daily[0].nightFeelsLikeTemperature);
      print(model.daily[0].nightFeelsLikeTemperatureAsF);
      print(model.daily[0].eveFeelsLikeTemperature);
      print(model.daily[0].eveFeelsLikeTemperatureAsF);
      print(model.daily[0].mornFeelsLikeTemperature);
      print(model.daily[0].mornFeelsLikeTemperatureAsF);
      print(model.daily[0].windSpeed);
      print(model.daily[0].windSpeedInMPH);
      print(model.daily[0].description);
      print(model.daily[0].icon);
      print(model.daily[0].dateTime);
      print(model.daily[0].timezoneSpecificDateTime);
      print(model.daily[0].temperatureIconDay);
      print(model.daily[0].temperatureIconEve);
      print(model.daily[0].temperatureIconMax);
      print(model.daily[0].temperatureIconMin);
      print(model.daily[0].temperatureIconMorn);
      print(model.daily[0].temperatureIconNight);
    }

    json['hourly'].forEach((h) {
      _hourly.add(
        WeatherModel(
          dateTime: unix(h['dt']),
          dateTimeIn24: unix24(h['dt']),
          timezoneSpecificDateTime: timezone(h['dt']),
          timezoneSpecificDateTimeIn24: timezone24(h['dt']),
          temperature: asC(h['temp']),
          temperatureAsF: asF(h['temp']),
          feelsLikeTemperature: asC(h['feels_like']),
          feelsLikeTemperatureAsF: asF(h['feels_like']),
          windSpeed: asMPS(h['wind_speed']),
          windSpeedInMPH: asMPH(h['wind_speed']),
          description: h['weather'][0]['description'],
          icon: h['weather'][0]['icon'],
          temperatureIcon: tempIcon(asInt(h['temp'])),
          day: day(h['dt']),
          timezoneSpecificDay: tzDay(h['dt']),
        ),
      );
    });

    json['daily'].forEach((d) {
      _daily.add(
        DailyWeatherModel(
          dateTime: unixWWD(d['dt']),
          timezoneSpecificDateTime: timezoneWWD(d['dt']),
          sunrise: unix(d['sunrise']),
          sunriseIn24: unix24(d['sunrise']),
          timezoneSpecificSunrise: timezone(d['sunrise']),
          timezoneSpecificSunriseIn24: timezone24(d['sunrise']),
          sunset: unix(d['sunset']),
          sunsetIn24: unix24(d['sunset']),
          timezoneSpecificSunset: timezone(d['sunset']),
          timezoneSpecificSunsetIn24: timezone24(d['sunset']),
          dayTemperature: asC(d['temp']['day']),
          dayTemperatureAsF: asF(d['temp']['day']),
          nightTemperature: asC(d['temp']['night']),
          nightTemperatureAsF: asF(d['temp']['night']),
          eveTemperature: asC(d['temp']['eve']),
          eveTemperatureAsF: asF(d['temp']['eve']),
          mornTemperature: asC(d['temp']['morn']),
          mornTemperatureAsF: asF(d['temp']['morn']),
          minTemperature: asC(d['temp']['min']),
          minTemperatureAsF: asF(d['temp']['min']),
          maxTemperature: asC(d['temp']['max']),
          maxTemperatureAsF: asF(d['temp']['max']),
          dayFeelsLikeTemperature: asC(d['feels_like']['day']),
          dayFeelsLikeTemperatureAsF: asF(d['feels_like']['day']),
          nightFeelsLikeTemperature: asC(d['feels_like']['night']),
          nightFeelsLikeTemperatureAsF: asF(d['feels_like']['night']),
          eveFeelsLikeTemperature: asC(d['feels_like']['eve']),
          eveFeelsLikeTemperatureAsF: asF(d['feels_like']['eve']),
          mornFeelsLikeTemperature: asC(d['feels_like']['morn']),
          mornFeelsLikeTemperatureAsF: asF(d['feels_like']['morn']),
          windSpeed: asMPS(d['wind_speed']),
          windSpeedInMPH: asMPH(d['wind_speed']),
          description: d['weather'][0]['description'],
          icon: d['weather'][0]['icon'],
          temperatureIconDay: tempIcon(asInt(d['temp']['day'])),
          temperatureIconNight: tempIcon(asInt(d['temp']['night'])),
          temperatureIconEve: tempIcon(asInt(d['temp']['eve'])),
          temperatureIconMorn: tempIcon(asInt(d['temp']['morn'])),
          temperatureIconMax: tempIcon(asInt(d['temp']['max'])),
          temperatureIconMin: tempIcon(asInt(d['temp']['min'])),
        ),
      );
    });

    final model = FullWeatherModel(
      timezone: json['timezone'],
      daytime: getDayTime(json['current']['dt']),
      sunrise: unix(json['current']['sunrise']),
      sunriseIn24: unix24(json['current']['sunrise']),
      sunset: unix(json['current']['sunset']),
      sunsetIn24: unix24(json['current']['sunset']),
      timezoneSpecificSunrise: timezone(json['current']['sunrise']),
      timezoneSpecificSunriseIn24: timezone24(json['current']['sunrise']),
      timezoneSpecificSunset: timezone(json['current']['sunset']),
      timezoneSpecificSunsetIn24: timezone24(json['current']['sunset']),
      current: WeatherModel(
        dateTime: unix(json['current']['dt']),
        dateTimeIn24: unix24(json['current']['dt']),
        timezoneSpecificDateTime: timezone(json['current']['dt']),
        timezoneSpecificDateTimeIn24: timezone24(json['current']['dt']),
        temperature: asC(json['current']['temp']),
        temperatureAsF: asF(json['current']['temp']),
        feelsLikeTemperature: asC(json['current']['feels_like']),
        feelsLikeTemperatureAsF: asF(json['current']['feels_like']),
        windSpeed: asMPS(json['current']['wind_speed']),
        windSpeedInMPH: asMPH(json['current']['wind_speed']),
        description: json['current']['weather'][0]['description'],
        icon: json['current']['weather'][0]['icon'],
        day: day(json['current']['dt']),
        timezoneSpecificDay: tzDay(json['current']['dt']),
        temperatureIcon: tempIcon(asInt(json['current']['temp'])),
      ),
      hourly: _hourly,
      daily: _daily,
    );
    // printAll(model);
    return model;
  }
}
