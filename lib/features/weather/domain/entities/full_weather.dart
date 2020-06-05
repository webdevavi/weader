import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import './weather_entities.dart';

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
