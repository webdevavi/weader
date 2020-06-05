import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:weader/features/time_aware_wallpaper/presentation/bloc/bloc.dart';
import 'package:weader/features/weather/presentation/widgets/weather_widgets.dart';

import '../../../../core/entities/entities.dart';
import '../../../../core/settings/settings.dart';
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
    String daytime;

    return BlocProvider(
      create: (_) => getIt<TimeAwareWallpaperBloc>(),
      child: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is WeatherEmpty) {
            return Container();
          } else if (state is WeatherLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is WeatherLoaded) {
            if (settings.dataPreference == DataPreference.TIMEZONE_SPECIFIC)
              daytime = state.weather.timezoneSpecificDaytime;
            else
              daytime = state.weather.daytime;

            if (settings.wallpaper == Wallpaper.TIME_AWARE) {
              BlocProvider.of<TimeAwareWallpaperBloc>(context).add(
                GetWallpaperEvent(daytime),
              );
              return BlocBuilder<TimeAwareWallpaperBloc,
                  TimeAwareWallpaperState>(
                builder: (context, wallpaperState) {
                  if (wallpaperState is TimeAwareWallpaperEmpty) {
                    return Container();
                  } else if (wallpaperState is TimeAwareWallpaperLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (wallpaperState is TimeAwareWallpaperLoaded) {
                    return forTimeAwareWallpaper(
                      wallpaperState,
                      location,
                      state,
                    );
                  } else if (wallpaperState is TimeAwareWallpaperError) {
                    return ErrorDisplay(message: wallpaperState.message);
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
            return ErrorDisplay(message: state.message);
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
          body: FullWeatherDisplay(
            location: location,
            weather: state.weather,
            settings: settings,
          ),
        ),
      ],
    );
  }

  Scaffold forStaticWallpaper(
    Location location,
    WeatherLoaded state,
  ) {
    return Scaffold(
      appBar: AppBar(
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
      body: FullWeatherDisplay(
        location: location,
        weather: state.weather,
        settings: settings,
      ),
    );
  }
}
