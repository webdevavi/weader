import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:weader/core/entities/settings.dart';
import 'package:weader/core/widgets/widgets.dart';
import 'package:weader/features/settings/presentation/bloc/bloc.dart';
import 'package:weader/features/settings/presentation/pages/settings_page.dart';
import 'package:weader/features/time_aware_wallpaper/presentation/bloc/bloc.dart';
import 'package:weader/features/weather/presentation/widgets/weather_widgets.dart';

import '../../../../core/entities/entities.dart';
import '../../../../core/widgets/error_display.dart';
import '../../../../injector.dart';
import '../bloc/bloc.dart';

class WeatherPage extends StatelessWidget {
  final Location location;
  const WeatherPage({Key key, @required this.location}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<WeatherBloc>(),
      child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, settings) {
        if (settings is SettingsLoaded)
          return WeatherPageBlocInit(
            location: this.location,
            settings: settings.settings,
          );
        return Container();
      }),
    );
  }
}

class WeatherPageBlocInit extends StatefulWidget {
  final Location location;
  final Settings settings;

  const WeatherPageBlocInit({
    Key key,
    @required this.location,
    @required this.settings,
  }) : super(key: key);
  @override
  _WeatherPageBlocInitState createState() => _WeatherPageBlocInitState();
}

class _WeatherPageBlocInitState extends State<WeatherPageBlocInit> {
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
    final settings = widget.settings;
    String daytime;

    return BlocProvider(
      create: (_) => getIt<TimeAwareWallpaperBloc>(),
      child: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is WeatherEmpty) {
            return Container();
          } else if (state is WeatherLoading) {
            return Scaffold(
              body: LoadingDisplay(),
            );
          } else if (state is WeatherLoaded) {
            if (settings.dataPreference == DataPreference(isLocal: true))
              daytime = state.weather.daytime;
            else
              daytime = state.weather.timezoneSpecificDaytime;

            if (settings.wallpaper == Wallpaper(isTimeAware: true)) {
              BlocProvider.of<TimeAwareWallpaperBloc>(context).add(
                GetWallpaperEvent(daytime),
              );
              return BlocBuilder<TimeAwareWallpaperBloc,
                  TimeAwareWallpaperState>(
                builder: (context, wallpaperState) {
                  if (wallpaperState is TimeAwareWallpaperEmpty) {
                    return Container();
                  } else if (wallpaperState is TimeAwareWallpaperLoading) {
                    return Scaffold(
                      body: LoadingDisplay(),
                    );
                  } else if (wallpaperState is TimeAwareWallpaperLoaded) {
                    return forTimeAwareWallpaper(
                      wallpaperState,
                      location,
                      state,
                    );
                  } else if (wallpaperState is TimeAwareWallpaperError) {
                    return Scaffold(
                      body: ErrorDisplay(
                        message: wallpaperState.message,
                      ),
                    );
                  }
                  return Container();
                },
              );
            } else {
              return forStaticWallpaper(
                location,
                state,
              );
            }
          } else if (state is WeatherError) {
            return Scaffold(
              body: ErrorDisplay(
                message: state.message,
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  Stack forTimeAwareWallpaper(
    TimeAwareWallpaperLoaded wallpaperState,
    Location location,
    WeatherLoaded state,
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
          appBarColor: Colors.transparent,
          location: location,
          state: state,
        ),
      ],
    );
  }

  Scaffold forStaticWallpaper(
    Location location,
    WeatherLoaded state,
  ) {
    return showScaffoldWithBackground(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBarColor: Theme.of(context).appBarTheme.color,
      location: location,
      state: state,
    );
  }

  Scaffold showScaffoldWithBackground({
    Color backgroundColor,
    Color appBarColor,
    Location location,
    WeatherLoaded state,
  }) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
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
        settings: widget.settings,
      ),
    );
  }
}
