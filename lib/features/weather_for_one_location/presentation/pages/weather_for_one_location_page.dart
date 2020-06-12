import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../../core/entities/entities.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../save_locations/presentation/widgets/save_location_button.dart';
import '../../../settings/presentation/bloc/bloc.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import '../../../time_aware_wallpaper/presentation/bloc/bloc.dart';
import '../bloc/bloc.dart';
import '../widgets/weather_widgets.dart';

class WeatherForOneLocationPage extends StatefulWidget {
  final Location location;

  const WeatherForOneLocationPage({
    Key key,
    @required this.location,
  }) : super(key: key);
  @override
  _WeatherForOneLocationPageState createState() =>
      _WeatherForOneLocationPageState();
}

class _WeatherForOneLocationPageState extends State<WeatherForOneLocationPage> {
  WeatherForOneLocationBloc weatherForOneLocationBloc;
  TimeAwareWallpaperBloc timeAwareWallpaperBloc;

  @override
  void initState() {
    super.initState();
    weatherForOneLocationBloc = BlocProvider.of<WeatherForOneLocationBloc>(
      context,
    );
    timeAwareWallpaperBloc = BlocProvider.of<TimeAwareWallpaperBloc>(
      context,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getWeather();
  }

  @override
  Widget build(BuildContext context) {
    final location = widget.location;
    Settings settings;

    return BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
      if (state is SettingsLoaded) {
        settings = state.settings;

        return BlocBuilder<WeatherForOneLocationBloc,
            WeatherForOneLocationState>(
          builder: (context, state) {
            if (state is WeatherForOneLocationEmpty) {
              return Container();
            } else if (state is WeatherForOneLocationLoading) {
              return Scaffold(
                body: LoadingDisplay(message: "Fetching weather forecast"),
              );
            } else if (state is WeatherForOneLocationLoaded) {
              final daytime = _getDaytime(settings, state);
              _getWallpaper(daytime);

              if (settings.wallpaper == Wallpaper(isTimeAware: true)) {
                return BlocBuilder<TimeAwareWallpaperBloc,
                    TimeAwareWallpaperState>(
                  builder: (context, wallpaperState) {
                    if (wallpaperState is TimeAwareWallpaperEmpty) {
                      return Container();
                    } else if (wallpaperState is TimeAwareWallpaperLoading) {
                      return Scaffold(
                        body: LoadingDisplay(message: "Downloading wallpaper"),
                      );
                    } else if (wallpaperState is TimeAwareWallpaperLoaded) {
                      return forTimeAwareWallpaper(
                        wallpaperState,
                        location,
                        state,
                        settings,
                      );
                    } else if (wallpaperState is TimeAwareWallpaperError) {
                      Navigator.of(context).pop(wallpaperState.message);
                    }
                    return Container();
                  },
                );
              } else {
                return forSolidBackground(
                  location,
                  state,
                  settings,
                );
              }
            } else if (state is WeatherForOneLocationError) {
              Navigator.of(context).pop(state.message);
            }
            return Container();
          },
        );
      }
      return Container();
    });
  }

  Stack forTimeAwareWallpaper(
    TimeAwareWallpaperLoaded wallpaperState,
    Location location,
    WeatherForOneLocationLoaded state,
    Settings settings,
  ) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Center(
          child: CircularProgressIndicator(),
        ),
        FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          image: wallpaperState.timeAwareWallpaper.url,
          fit: BoxFit.cover,
        ),
        Container(
          color: Colors.black.withOpacity(0.4),
        ),
        showScaffoldWithBackground(
          backgroundColor: Colors.transparent,
          location: location,
          state: state,
          settings: settings,
        ),
      ],
    );
  }

  Scaffold forSolidBackground(
    Location location,
    WeatherForOneLocationLoaded state,
    Settings settings,
  ) {
    return showScaffoldWithBackground(
      location: location,
      state: state,
      settings: settings,
    );
  }

  Scaffold showScaffoldWithBackground({
    Color backgroundColor,
    Location location,
    WeatherForOneLocationLoaded state,
    Settings settings,
  }) {
    IconThemeData iconThemeData() {
      if (settings.wallpaper.isTimeAware)
        return IconThemeData(color: Colors.white);
    }

    TextStyle textStyle() {
      if (settings.wallpaper.isTimeAware) return TextStyle(color: Colors.white);
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: SmallIconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back),
        ),
        iconTheme: iconThemeData(),
        title: Text(
          location.displayName,
          style: textStyle(),
        ),
        actions: <Widget>[
          SaveLocationButton(location: location),
          SmallIconButton(
            onPressed: _getWeather,
            icon: Icon(Icons.refresh),
          ),
          SmallIconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(),
                ),
              );
            },
            icon: Icon(Icons.settings),
          )
        ],
      ),
      body: FullWeatherDisplay(
        location: location,
        weather: state.weather,
        settings: settings,
      ),
    );
  }

  String _getDaytime(
    Settings settings,
    WeatherForOneLocationLoaded state,
  ) {
    if (settings.dataPreference == DataPreference(isLocal: true))
      return state.weather.daytime;
    else
      return state.weather.timezoneSpecificDaytime;
  }

  void _getWeather() =>
      weatherForOneLocationBloc.add(GetWeatherForOneLocationEvent(
        latitude: widget.location.latitude,
        longitude: widget.location.longitude,
      ));

  void _getWallpaper(String daytime) =>
      BlocProvider.of<TimeAwareWallpaperBloc>(context).add(
        GetWallpaperEvent(daytime),
      );
}
