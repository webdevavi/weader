import 'package:flutter/material.dart';

import '../../../../core/entities/entities.dart';
import 'weather_widgets.dart';

class FullWeatherDisplay extends StatelessWidget {
  const FullWeatherDisplay({
    Key key,
    @required this.location,
    @required this.weather,
    @required this.settings,
  }) : super(key: key);

  final Location location;
  final FullWeather weather;
  final Settings settings;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8.0,
        right: 8.0,
        left: 8.0,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 8,
            child: Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: Column(
                children: <Widget>[
                  CurrentWeatherDisplay(
                    location: location,
                    weather: weather,
                    settings: settings,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Expanded(
                    child: DailyWeatherDisplay(
                      dailyWeather: weather.daily,
                      settings: settings,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 4.0,
              ),
              child: HourlyWeatherDisplay(
                hourlyWeather: weather.hourly,
                settings: settings,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
