import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../../core/entities/entities.dart';
import '../../../../core/settings/settings.dart';
import '../../../../core/widgets/error_display.dart';
import '../../../../injector.dart';
import '../../domain/entities/weather_entities.dart';
import '../bloc/bloc.dart';

class WeatherPage extends StatelessWidget {
  final Location location;
  const WeatherPage({Key key, @required this.location}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<WeatherBloc>(),
      child: WeatherPageBlocInit(location: this.location),
    );
  }
}

class WeatherPageBlocInit extends StatefulWidget {
  final Location location;

  const WeatherPageBlocInit({Key key, @required this.location})
      : super(key: key);
  @override
  _WeatherPageBlocInitState createState() => _WeatherPageBlocInitState();
}

class _WeatherPageBlocInitState extends State<WeatherPageBlocInit> {
  final Settings settings = Settings();

  void getWeather() =>
      BlocProvider.of<WeatherBloc>(context).add(GetWeatherEvent(
        latitude: widget.location.latitude,
        longitude: widget.location.longitude,
      ));
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getWeather();
  }

  @override
  Widget build(BuildContext context) {
    final location = widget.location;
    final wallpaper =
        "https://images.unsplash.com/photo-1518418349884-616fb4553500?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max&ixid=eyJhcHBfaWQiOjEzNTcxMX0";
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        if (state is Empty) {
          return Container();
        } else if (state is Loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is Loaded) {
          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Center(child: CircularProgressIndicator()),
              FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: wallpaper,
                fit: BoxFit.cover,
              ),
              Container(
                color: Colors.black.withOpacity(0.4),
              ),
              Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  leading: BackButton(),
                  title: Text(location.displayName),
                  actions: <Widget>[
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.add_location),
                    ),
                    IconButton(
                      onPressed: getWeather,
                      icon: Icon(Icons.refresh),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.settings),
                    )
                  ],
                ),
                body: Padding(
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
                                weather: state.weather,
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
                                  dailyWeather: state.weather.daily,
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
                            hourlyWeather: state.weather.hourly,
                            settings: settings,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else if (state is Error) {
          return ErrorDisplay(message: state.message);
        }
        return Container();
      },
    );
  }
}

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
