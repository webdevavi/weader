import 'package:flutter/material.dart';

import '../../../../core/entities/entities.dart';
import '../../../../core/settings/settings.dart';
import '../../domain/entities/weather_entities.dart';

class CurrentWeatherDisplay extends StatelessWidget {
  final Location location;
  final FullWeather weather;
  final Settings settings;

  const CurrentWeatherDisplay({
    Key key,
    @required this.location,
    @required this.weather,
    @required this.settings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String dateTime;
    String day;
    String temperature;
    String feelsLikeTemperature;
    String sunrise;
    String sunset;
    String windSpeed;

    void setUp() {
      if (settings.dataPreference == DataPreference.LOCAL) {
        day = weather.current.day;
        if (settings.timeFormat == TimeFormat.HOURS24) {
          dateTime = weather.current.dateTimeIn24;
          sunrise = weather.sunriseIn24;
          sunset = weather.sunsetIn24;
        } else if (settings.timeFormat == TimeFormat.HOURS12) {
          dateTime = weather.current.dateTime;
          sunrise = weather.sunrise;
          sunset = weather.sunset;
        }
      } else if (settings.dataPreference == DataPreference.TIMEZONE_SPECIFIC) {
        day = weather.current.timezoneSpecificDay;
        if (settings.timeFormat == TimeFormat.HOURS24) {
          dateTime = weather.current.timezoneSpecificDateTimeIn24;
          sunrise = weather.timezoneSpecificSunriseIn24;
          sunset = weather.timezoneSpecificSunsetIn24;
        } else if (settings.timeFormat == TimeFormat.HOURS12) {
          dateTime = weather.current.timezoneSpecificDateTime;
          sunrise = weather.timezoneSpecificSunrise;
          sunset = weather.timezoneSpecificSunset;
        }
      }

      if (settings.unit == Unit.METRIC) {
        temperature = weather.current.temperature;
        feelsLikeTemperature = weather.current.feelsLikeTemperature;
        windSpeed = weather.current.windSpeed;
      } else if (settings.unit == Unit.IMPERIAL) {
        temperature = weather.current.temperatureAsF;
        feelsLikeTemperature = weather.current.feelsLikeTemperatureAsF;
        windSpeed = weather.current.windSpeedInMPH;
      }
    }

    Text textDivider(
      double fontSize,
      Color color,
    ) {
      return Text(
        ' | ',
        style: TextStyle(
          fontSize: fontSize,
          color: color,
        ),
      );
    }

    setUp();

    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                dateTime,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.white70,
                ),
              ),
              textDivider(
                14.0,
                Colors.white70,
              ),
              Text(
                weather.timezone,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.white70,
                ),
              ),
              textDivider(
                14.0,
                Colors.white70,
              ),
              Text(
                day,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      location.displayName,
                      style: TextStyle(
                        fontSize: 26.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      location.address,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.white70,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 50.0,
                      height: 50.0,
                      child: Image(
                        image: AssetImage(
                          "icons/${weather.current.icon}.png",
                        ),
                        width: 50.0,
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      weather.current.description.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 12.0,
          ),
          Row(
            children: <Widget>[
              Image(
                image: AssetImage(
                    "icons/${weather.current.temperatureIcon}_temperature.png"),
                width: 18.0,
              ),
              Text(
                temperature,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                " ~ ",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                feelsLikeTemperature,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 12.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                    image: AssetImage("icons/sunrise.png"),
                    height: 36,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    sunrise,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Sunrise",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                    image: AssetImage("icons/sunset.png"),
                    height: 36,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    sunset,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Sunset",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                    image: AssetImage("icons/wind.png"),
                    height: 36,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    windSpeed,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Wind",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
