import 'package:flutter/material.dart';

import '../../../../core/settings/settings.dart';
import '../../domain/entities/weather_entities.dart';

class HourlyWeatherDisplay extends StatelessWidget {
  final List<Weather> hourlyWeather;
  final Settings settings;

  const HourlyWeatherDisplay({
    Key key,
    @required this.hourlyWeather,
    @required this.settings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String dateTime;
    String day;
    String temperature;
    String icon;
    String temperatureIcon;

    void setUp(index) {
      icon = hourlyWeather[index].icon;
      temperatureIcon = hourlyWeather[index].temperatureIcon;
      if (settings.dataPreference == DataPreference.LOCAL) {
        day = hourlyWeather[index].day;
        if (settings.timeFormat == TimeFormat.HOURS24) {
          dateTime = hourlyWeather[index].dateTimeIn24;
        } else if (settings.timeFormat == TimeFormat.HOURS12) {
          dateTime = hourlyWeather[index].dateTime;
        }
      } else if (settings.dataPreference == DataPreference.TIMEZONE_SPECIFIC) {
        day = hourlyWeather[index].timezoneSpecificDay;
        if (settings.timeFormat == TimeFormat.HOURS24) {
          dateTime = hourlyWeather[index].timezoneSpecificDateTimeIn24;
        } else if (settings.timeFormat == TimeFormat.HOURS12) {
          dateTime = hourlyWeather[index].timezoneSpecificDateTime;
        }
      }

      if (settings.unit == Unit.METRIC) {
        temperature = hourlyWeather[index].temperature;
      } else if (settings.unit == Unit.IMPERIAL) {
        temperature = hourlyWeather[index].temperatureAsF;
      }
    }

    return ListView.builder(
      itemCount: hourlyWeather.length,
      itemBuilder: (context, index) {
        setUp(index);
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Container(
                    width: 30.0,
                    height: 30.0,
                    child: Image(
                      image: AssetImage(
                        "icons/$icon.png",
                      ),
                      width: 30.0,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(
                        image: AssetImage(
                          "icons/${temperatureIcon}_temperature.png",
                        ),
                        width: 10.0,
                      ),
                      SizedBox(
                        width: 4.0,
                      ),
                      Text(
                        temperature,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Text(
                    dateTime,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    day,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
