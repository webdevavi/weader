import 'package:flutter/material.dart';

import '../../../../core/entities/entities.dart';

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
    Color cardColor;

    void setUp(index) {
      if (settings.wallpaper.isTimeAware)
        cardColor = Colors.black.withOpacity(0.2);
      else if (settings.currentTheme.isDark)
        cardColor = Theme.of(context).primaryColor;
      else
        cardColor = Theme.of(context).accentColor;
      temperatureIconMorn = dailyWeather[index].temperatureIconMorn;
      temperatureIconEve = dailyWeather[index].temperatureIconEve;
      temperatureIconDay = dailyWeather[index].temperatureIconDay;
      temperatureIconNight = dailyWeather[index].temperatureIconNight;
      temperatureIconMax = dailyWeather[index].temperatureIconMax;
      temperatureIconMin = dailyWeather[index].temperatureIconMin;
      description = dailyWeather[index].description;
      icon = dailyWeather[index].icon;
      if (settings.dataPreference == DataPreference(isLocal: true)) {
        dateTime = dailyWeather[index].dateTime;
        if (settings.timeFormat == TimeFormat(is24Hours: true)) {
          sunrise = dailyWeather[index].sunriseIn24;
          sunset = dailyWeather[index].sunsetIn24;
        } else {
          sunrise = dailyWeather[index].sunrise;
          sunset = dailyWeather[index].sunset;
        }
      } else {
        dateTime = dailyWeather[index].timezoneSpecificDateTime;
        if (settings.timeFormat == TimeFormat(is24Hours: true)) {
          sunrise = dailyWeather[index].timezoneSpecificSunriseIn24;
          sunset = dailyWeather[index].timezoneSpecificSunsetIn24;
        } else {
          sunrise = dailyWeather[index].timezoneSpecificSunrise;
          sunset = dailyWeather[index].timezoneSpecificSunset;
        }
      }

      if (settings.unitSystem == UnitSystem(isImperial: true)) {
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
      } else {
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
              color: cardColor,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  dateTime,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12.0,
                  ),
                ),
                SizedBox(
                  height: 12.0,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Wrap(
                        alignment: WrapAlignment.spaceAround,
                        children: <Widget>[
                          _showMinMax(
                            icon: "icons/${temperatureIconMax}_temperature.png",
                            value: maxTemperature,
                            label: "MAX",
                          ),
                          _showMinMax(
                            icon: "icons/${temperatureIconMin}_temperature.png",
                            value: minTemperature,
                            label: "MIN",
                          ),
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image(
                                  image: AssetImage(
                                    "icons/$icon.png",
                                  ),
                                  height: 24.0,
                                ),
                                Text(
                                  description.toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Wrap(
                        alignment: WrapAlignment.spaceAround,
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
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Wrap(
                        alignment: WrapAlignment.spaceAround,
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

  Container _showMinMax({
    String icon,
    String value,
    String label,
  }) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage(
                  icon,
                ),
                height: 24.0,
              ),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16.0,
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
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _showSunriseOrSunsetOrWind({
    String icon,
    String value,
    String label,
  }) {
    return Container(
      child: Column(
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
              color: Colors.white70,
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white60,
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Padding _showTemperature({
    String label,
    String icon,
    String temp,
    String feelsLikeTemp,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              label,
              style: TextStyle(
                color: Colors.white60,
                fontWeight: FontWeight.bold,
                fontSize: 12.0,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                  image: AssetImage("icons/${icon}_temperature.png"),
                  height: 24,
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
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      feelsLikeTemp,
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
