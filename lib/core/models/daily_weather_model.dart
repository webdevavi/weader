import 'package:Weader/core/entities/entities.dart';
import 'package:Weader/core/util/datetime_converter.dart';
import 'package:meta/meta.dart';

class DailyWeatherModel extends DailyWeather {
  final String dateTime;
  final String timezoneSpecificDateTime;
  final String sunrise;
  final String sunriseIn24;
  final String timezoneSpecificSunrise;
  final String timezoneSpecificSunriseIn24;
  final String sunset;
  final String sunsetIn24;
  final String timezoneSpecificSunset;
  final String timezoneSpecificSunsetIn24;
  final String dayTemperature;
  final String dayTemperatureAsF;
  final String nightTemperature;
  final String nightTemperatureAsF;
  final String eveTemperature;
  final String eveTemperatureAsF;
  final String mornTemperature;
  final String mornTemperatureAsF;
  final String minTemperature;
  final String minTemperatureAsF;
  final String maxTemperature;
  final String maxTemperatureAsF;
  final String dayFeelsLikeTemperature;
  final String dayFeelsLikeTemperatureAsF;
  final String nightFeelsLikeTemperature;
  final String nightFeelsLikeTemperatureAsF;
  final String eveFeelsLikeTemperature;
  final String eveFeelsLikeTemperatureAsF;
  final String mornFeelsLikeTemperature;
  final String mornFeelsLikeTemperatureAsF;
  final String windSpeed;
  final String windSpeedInMPH;
  final String description;
  final String icon;
  final String temperatureIconDay;
  final String temperatureIconNight;
  final String temperatureIconEve;
  final String temperatureIconMorn;
  final String temperatureIconMax;
  final String temperatureIconMin;

  DailyWeatherModel({
    @required this.dateTime,
    @required this.timezoneSpecificDateTime,
    @required this.sunrise,
    @required this.sunriseIn24,
    @required this.timezoneSpecificSunrise,
    @required this.timezoneSpecificSunriseIn24,
    @required this.sunset,
    @required this.sunsetIn24,
    @required this.timezoneSpecificSunset,
    @required this.timezoneSpecificSunsetIn24,
    @required this.dayTemperature,
    @required this.dayTemperatureAsF,
    @required this.nightTemperature,
    @required this.nightTemperatureAsF,
    @required this.eveTemperature,
    @required this.eveTemperatureAsF,
    @required this.mornTemperature,
    @required this.mornTemperatureAsF,
    @required this.minTemperature,
    @required this.minTemperatureAsF,
    @required this.maxTemperature,
    @required this.maxTemperatureAsF,
    @required this.dayFeelsLikeTemperature,
    @required this.dayFeelsLikeTemperatureAsF,
    @required this.nightFeelsLikeTemperature,
    @required this.nightFeelsLikeTemperatureAsF,
    @required this.eveFeelsLikeTemperature,
    @required this.eveFeelsLikeTemperatureAsF,
    @required this.mornFeelsLikeTemperature,
    @required this.mornFeelsLikeTemperatureAsF,
    @required this.windSpeed,
    @required this.windSpeedInMPH,
    @required this.description,
    @required this.icon,
    @required this.temperatureIconDay,
    @required this.temperatureIconNight,
    @required this.temperatureIconEve,
    @required this.temperatureIconMorn,
    @required this.temperatureIconMax,
    @required this.temperatureIconMin,
  });

  factory DailyWeatherModel.fromJson({
    @required Map<String, dynamic> json,
    @required DateTimeConverter dateTimeConverter,
    @required String timezone,
  }) {
    String unix(timestamp) => dateTimeConverter.convertUnix(
          timestamp: timestamp,
        );
    String unixWWD(timestamp) => dateTimeConverter.convertUnix(
          timestamp: timestamp,
          format: Format.WeekdayWithDate,
        );
    String tz(timestamp) => dateTimeConverter.convertSpecificTimezone(
          timezone: timezone,
          timestamp: timestamp,
        );
    String timezoneWWD(timestamp) => dateTimeConverter.convertSpecificTimezone(
          timezone: timezone,
          timestamp: timestamp,
          format: Format.WeekdayWithDate,
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

    return DailyWeatherModel(
      dateTime: unixWWD(json['dt']),
      timezoneSpecificDateTime: timezoneWWD(json['dt']),
      sunrise: unix(json['sunrise']),
      sunriseIn24: unix24(json['sunrise']),
      timezoneSpecificSunrise: tz(json['sunrise']),
      timezoneSpecificSunriseIn24: timezone24(json['sunrise']),
      sunset: unix(json['sunset']),
      sunsetIn24: unix24(json['sunset']),
      timezoneSpecificSunset: tz(json['sunset']),
      timezoneSpecificSunsetIn24: timezone24(json['sunset']),
      dayTemperature: asC(json['temp']['day']),
      dayTemperatureAsF: asF(json['temp']['day']),
      nightTemperature: asC(json['temp']['night']),
      nightTemperatureAsF: asF(json['temp']['night']),
      eveTemperature: asC(json['temp']['eve']),
      eveTemperatureAsF: asF(json['temp']['eve']),
      mornTemperature: asC(json['temp']['morn']),
      mornTemperatureAsF: asF(json['temp']['morn']),
      minTemperature: asC(json['temp']['min']),
      minTemperatureAsF: asF(json['temp']['min']),
      maxTemperature: asC(json['temp']['max']),
      maxTemperatureAsF: asF(json['temp']['max']),
      dayFeelsLikeTemperature: asC(json['feels_like']['day']),
      dayFeelsLikeTemperatureAsF: asF(json['feels_like']['day']),
      nightFeelsLikeTemperature: asC(json['feels_like']['night']),
      nightFeelsLikeTemperatureAsF: asF(json['feels_like']['night']),
      eveFeelsLikeTemperature: asC(json['feels_like']['eve']),
      eveFeelsLikeTemperatureAsF: asF(json['feels_like']['eve']),
      mornFeelsLikeTemperature: asC(json['feels_like']['morn']),
      mornFeelsLikeTemperatureAsF: asF(json['feels_like']['morn']),
      windSpeed: asMPS(json['wind_speed']),
      windSpeedInMPH: asMPH(json['wind_speed']),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
      temperatureIconDay: tempIcon(asInt(json['temp']['day'])),
      temperatureIconNight: tempIcon(asInt(json['temp']['night'])),
      temperatureIconEve: tempIcon(asInt(json['temp']['eve'])),
      temperatureIconMorn: tempIcon(asInt(json['temp']['morn'])),
      temperatureIconMax: tempIcon(asInt(json['temp']['max'])),
      temperatureIconMin: tempIcon(asInt(json['temp']['min'])),
    );
  }
}
