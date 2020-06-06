import 'package:flutter/material.dart';

import '../../../../core/entities/entities.dart';
import '../../../../core/entities/settings.dart';
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
      if (settings.dataPreference == DataPreference(isLocal: true)) {
        day = weather.current.day;
        if (settings.timeFormat == TimeFormat(is24Hours: true)) {
          dateTime = weather.current.dateTimeIn24;
          sunrise = weather.sunriseIn24;
          sunset = weather.sunsetIn24;
        } else {
          dateTime = weather.current.dateTime;
          sunrise = weather.sunrise;
          sunset = weather.sunset;
        }
      } else {
        day = weather.current.timezoneSpecificDay;
        if (settings.timeFormat == TimeFormat(is24Hours: true)) {
          dateTime = weather.current.timezoneSpecificDateTimeIn24;
          sunrise = weather.timezoneSpecificSunriseIn24;
          sunset = weather.timezoneSpecificSunsetIn24;
        } else {
          dateTime = weather.current.timezoneSpecificDateTime;
          sunrise = weather.timezoneSpecificSunrise;
          sunset = weather.timezoneSpecificSunset;
        }
      }

      if (settings.unitSystem == UnitSystem(isImperial: true)) {
        temperature = weather.current.temperatureAsF;
        feelsLikeTemperature = weather.current.feelsLikeTemperatureAsF;
        windSpeed = weather.current.windSpeedInMPH;
      } else {
        temperature = weather.current.temperature;
        feelsLikeTemperature = weather.current.feelsLikeTemperature;
        windSpeed = weather.current.windSpeed;
      }
    }

    RichText showTimezone() {
      if (settings.dataPreference.isLocal == false)
        return RichText(
          textAlign: TextAlign.start,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            text: dateTime,
            style: TextStyle(
              fontSize: 12.0,
            ),
            children: [
              TextSpan(text: " | "),
              TextSpan(text: weather.timezone),
              TextSpan(text: " | "),
              TextSpan(text: day),
            ],
          ),
        );
      else
        return RichText(
          textAlign: TextAlign.start,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            text: dateTime,
            style: TextStyle(
              fontSize: 12.0,
            ),
            children: [
              TextSpan(text: " | "),
              TextSpan(text: day),
            ],
          ),
        );
    }

    setUp();

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height / 2.5,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              showTimezone(),
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
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 24.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          location.address,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.0,
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
                            fontSize: 10.0,
                            color: Colors.white,
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
                children: <Widget>[
                  Image(
                    image: AssetImage(
                        "icons/${weather.current.temperatureIcon}_temperature.png"),
                    width: 18.0,
                  ),
                  Expanded(
                    child: RichText(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        text: temperature,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36.0,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: " ~ ",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 28.0,
                            ),
                          ),
                          TextSpan(
                            text: feelsLikeTemperature,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 28.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
                        _showSunsetSunriseWind(
                          icon: "sunrise",
                          value: sunrise,
                          label: "Sunrise",
                        ),
                        _showSunsetSunriseWind(
                          icon: "sunset",
                          value: sunset,
                          label: "Sunset",
                        ),
                        _showSunsetSunriseWind(
                          icon: "wind",
                          value: windSpeed,
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
      ),
    );
  }

  Container _showSunsetSunriseWind({
    @required String icon,
    @required String label,
    @required String value,
  }) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(
            image: AssetImage("icons/$icon.png"),
            height: 32,
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
