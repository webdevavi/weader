import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class FullWeather extends Equatable {
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
  final List<Weather> hourly;
  final List<DailyWeather> daily;

  FullWeather({
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

  @override
  List<Object> get props => [
        timezone,
        daytime,
        timezoneSpecificDaytime,
        sunrise,
        sunriseIn24,
        timezoneSpecificSunrise,
        timezoneSpecificSunriseIn24,
        timezoneSpecificSunset,
        timezoneSpecificSunsetIn24,
        sunset,
        sunsetIn24,
        current,
        hourly,
        daily,
      ];
}

class DailyWeather extends Equatable {
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

  DailyWeather({
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
  @override
  List<Object> get props => [
        dateTime,
        timezoneSpecificDateTime,
        sunrise,
        sunriseIn24,
        timezoneSpecificSunrise,
        timezoneSpecificSunriseIn24,
        sunset,
        sunsetIn24,
        timezoneSpecificSunset,
        timezoneSpecificSunsetIn24,
        dayTemperature,
        dayTemperatureAsF,
        nightTemperature,
        nightTemperatureAsF,
        eveTemperature,
        eveTemperatureAsF,
        mornTemperature,
        mornTemperatureAsF,
        minTemperature,
        minTemperatureAsF,
        maxTemperature,
        maxTemperatureAsF,
        dayFeelsLikeTemperature,
        dayFeelsLikeTemperatureAsF,
        nightFeelsLikeTemperature,
        nightFeelsLikeTemperatureAsF,
        eveFeelsLikeTemperature,
        eveFeelsLikeTemperatureAsF,
        mornFeelsLikeTemperature,
        mornFeelsLikeTemperatureAsF,
        windSpeed,
        description,
        icon,
        temperatureIconDay,
        temperatureIconNight,
        temperatureIconEve,
        temperatureIconMorn,
        temperatureIconMax,
        temperatureIconMin,
      ];
}

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
