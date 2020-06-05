import 'package:flutter/material.dart';

import '../../../../core/settings/settings.dart';
import '../../domain/entities/weather_entities.dart';

class DailyWeatherDisplay extends StatelessWidget {
  final List<DailyWeather> dailyWeather;
  final Settings settings;

  const DailyWeatherDisplay({
    Key key,
    @required this.dailyWeather,
    @required this.settings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String dateTime;
    String sunrise;
    String sunset;
    String dayTemperature;
    String nightTemperature;
    String eveTemperature;
    String mornTemperature;
    String minTemperature;
    String maxTemperature;
    String dayFeelsLikeTemperature;
    String nightFeelsLikeTemperature;
    String eveFeelsLikeTemperature;
    String mornFeelsLikeTemperature;
    String windSpeed;
    String temperatureIconMorn;
    String temperatureIconEve;
    String temperatureIconDay;
    String temperatureIconNight;
    String temperatureIconMax;
    String temperatureIconMin;
    String description;
    String icon;

    void setUp(index) {
      temperatureIconMorn = dailyWeather[index].temperatureIconMorn;
      temperatureIconEve = dailyWeather[index].temperatureIconEve;
      temperatureIconDay = dailyWeather[index].temperatureIconDay;
      temperatureIconNight = dailyWeather[index].temperatureIconNight;
      temperatureIconMax = dailyWeather[index].temperatureIconMax;
      temperatureIconMin = dailyWeather[index].temperatureIconMin;
      description = dailyWeather[index].description;
      icon = dailyWeather[index].icon;
      if (settings.dataPreference == DataPreference.LOCAL) {
        dateTime = dailyWeather[index].dateTime;
        if (settings.timeFormat == TimeFormat.HOURS24) {
          sunrise = dailyWeather[index].sunriseIn24;
          sunset = dailyWeather[index].sunsetIn24;
        } else if (settings.timeFormat == TimeFormat.HOURS12) {
          sunrise = dailyWeather[index].sunrise;
          sunset = dailyWeather[index].sunset;
        }
      } else if (settings.dataPreference == DataPreference.TIMEZONE_SPECIFIC) {
        dateTime = dailyWeather[index].timezoneSpecificDateTime;
        if (settings.timeFormat == TimeFormat.HOURS24) {
          sunrise = dailyWeather[index].timezoneSpecificSunriseIn24;
          sunset = dailyWeather[index].timezoneSpecificSunsetIn24;
        } else if (settings.timeFormat == TimeFormat.HOURS12) {
          sunrise = dailyWeather[index].timezoneSpecificSunrise;
          sunset = dailyWeather[index].timezoneSpecificSunset;
        }
      }

      if (settings.unit == Unit.METRIC) {
        dayTemperature = dailyWeather[index].dayTemperature;
        nightTemperature = dailyWeather[index].nightTemperature;
        eveTemperature = dailyWeather[index].eveTemperature;
        mornTemperature = dailyWeather[index].mornTemperature;
        minTemperature = dailyWeather[index].minTemperature;
        maxTemperature = dailyWeather[index].maxTemperature;
        dayFeelsLikeTemperature = dailyWeather[index].dayFeelsLikeTemperature;
        nightFeelsLikeTemperature =
            dailyWeather[index].nightFeelsLikeTemperature;
        eveFeelsLikeTemperature = dailyWeather[index].eveFeelsLikeTemperature;
        mornFeelsLikeTemperature = dailyWeather[index].mornFeelsLikeTemperature;
        windSpeed = dailyWeather[index].windSpeed;
      } else if (settings.unit == Unit.IMPERIAL) {
        dayTemperature = dailyWeather[index].dayTemperatureAsF;
        nightTemperature = dailyWeather[index].nightTemperatureAsF;
        eveTemperature = dailyWeather[index].eveTemperatureAsF;
        mornTemperature = dailyWeather[index].mornTemperatureAsF;
        minTemperature = dailyWeather[index].minTemperatureAsF;
        maxTemperature = dailyWeather[index].maxTemperatureAsF;
        dayFeelsLikeTemperature =
            dailyWeather[index].dayFeelsLikeTemperatureAsF;
        nightFeelsLikeTemperature =
            dailyWeather[index].nightFeelsLikeTemperatureAsF;
        eveFeelsLikeTemperature =
            dailyWeather[index].eveFeelsLikeTemperatureAsF;
        mornFeelsLikeTemperature =
            dailyWeather[index].mornFeelsLikeTemperatureAsF;
        windSpeed = dailyWeather[index].windSpeedInMPH;
      }
    }

    return ListView.builder(
      itemCount: dailyWeather.length - 1,
      itemBuilder: (context, index) {
        setUp(index + 1);
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  dateTime,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14.0,
                  ),
                ),
                SizedBox(
                  height: 12.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: _showMinMax(
                        icon: "icons/${temperatureIconMax}_temperature.png",
                        value: maxTemperature,
                        label: "MAX",
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: _showMinMax(
                        icon: "icons/${temperatureIconMin}_temperature.png",
                        value: minTemperature,
                        label: "MIN",
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image(
                            image: AssetImage(
                              "icons/$icon.png",
                            ),
                            height: 30.0,
                          ),
                          Text(
                            description.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _showTemperature(
                      label: "MORNING",
                      icon: temperatureIconMorn,
                      temp: mornTemperature,
                      feelsLikeTemp: mornFeelsLikeTemperature,
                    ),
                    _showTemperature(
                      label: "DAY",
                      icon: temperatureIconDay,
                      temp: dayTemperature,
                      feelsLikeTemp: dayFeelsLikeTemperature,
                    ),
                    _showTemperature(
                      label: "EVENING",
                      icon: temperatureIconEve,
                      temp: eveTemperature,
                      feelsLikeTemp: eveFeelsLikeTemperature,
                    ),
                    _showTemperature(
                      label: "NIGHT",
                      icon: temperatureIconNight,
                      temp: nightTemperature,
                      feelsLikeTemp: nightFeelsLikeTemperature,
                    ),
                  ],
                ),
                SizedBox(
                  height: 12.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _showSunriseOrSunsetOrWind(
                      value: sunrise,
                      icon: "sunrise",
                      label: "Sunrise",
                    ),
                    _showSunriseOrSunsetOrWind(
                      value: sunset,
                      icon: "sunset",
                      label: "Sunset",
                    ),
                    _showSunriseOrSunsetOrWind(
                      value: windSpeed,
                      icon: "wind",
                      label: "Wind",
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _showMinMax({
    String icon,
    String value,
    String label,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage(
                icon,
              ),
              height: 30.0,
            ),
            Text(
              value,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Text(
          label.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white60,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _showSunriseOrSunsetOrWind({
    String icon,
    String value,
    String label,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image(
          image: AssetImage("icons/$icon.png"),
          height: 24,
        ),
        SizedBox(
          height: 8.0,
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _showTemperature({
    String label,
    String icon,
    String temp,
    String feelsLikeTemp,
  }) {
    return Column(
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            color: Colors.white60,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: <Widget>[
            Image(
              image: AssetImage("icons/${icon}_temperature.png"),
              width: 14,
            ),
            SizedBox(
              width: 4.0,
            ),
            Column(
              children: <Widget>[
                Text(
                  temp,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  feelsLikeTemp,
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}