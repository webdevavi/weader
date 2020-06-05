import 'package:flutter/material.dart';
import 'package:weader/core/entities/entities.dart';
import 'package:weader/core/settings/settings.dart';
import 'package:weader/features/weather/domain/entities/weather_entities.dart';
import 'package:weader/features/weather/presentation/widgets/weather_widgets.dart';

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
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Forecast for next 7 days",
                            style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white70,
                          ),
                        ],
                      ),
                    ),
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
