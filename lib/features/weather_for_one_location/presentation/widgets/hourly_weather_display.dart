import 'package:flutter/material.dart';

import '../../../../core/entities/entities.dart';

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
    Color cardColor;

    void setUp(index) {
      icon = hourlyWeather[index].icon;
      temperatureIcon = hourlyWeather[index].temperatureIcon;
      if (settings.dataPreference == DataPreference(isLocal: true)) {
        day = hourlyWeather[index].day;
        if (settings.timeFormat == TimeFormat(is24Hours: true)) {
          dateTime = hourlyWeather[index].dateTimeIn24;
        } else {
          dateTime = hourlyWeather[index].dateTime;
        }
      } else {
        day = hourlyWeather[index].timezoneSpecificDay;
        if (settings.timeFormat == TimeFormat(is24Hours: true)) {
          dateTime = hourlyWeather[index].timezoneSpecificDateTimeIn24;
        } else {
          dateTime = hourlyWeather[index].timezoneSpecificDateTime;
        }
      }

      if (settings.unitSystem == UnitSystem(isImperial: true)) {
        temperature = hourlyWeather[index].temperatureAsF;
      } else {
        temperature = hourlyWeather[index].temperature;
      }

      if (settings.wallpaper.isTimeAware)
        cardColor = Colors.black.withOpacity(0.2);
      else if (settings.currentTheme.isDark)
        cardColor = Theme.of(context).primaryColor;
      else
        cardColor = Theme.of(context).accentColor;
    }

    return ListView.builder(
      itemCount: hourlyWeather.length,
      itemBuilder: (context, index) {
        setUp(index);
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
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
                  Row(
                    children: <Widget>[
                      Image(
                        image: AssetImage(
                          "icons/${temperatureIcon}_temperature.png",
                        ),
                        height: 20.0,
                      ),
                      Expanded(
                        child: Text(
                          temperature,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Text(
                    dateTime,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12.0,
                    ),
                  ),
                  Text(
                    day,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 10.0,
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
