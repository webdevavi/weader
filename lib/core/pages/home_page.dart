import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/save_locations/presentation/bloc/bloc.dart';
import '../../features/search_locations/presentation/pages/search_page.dart';
import '../../features/settings/presentation/bloc/bloc.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/weather_for_saved_locations/presentation/bloc/bloc.dart';
import '../../features/weather_for_saved_locations/presentation/widgets/weather_for_saved_locations_display.dart';
import '../entities/entities.dart';
import '../snack_bar/show_snack_bar.dart';
import '../widgets/widgets.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WeatherForSavedLocationsBloc _weatherBloc;
  SaveLocationsBloc _locationsBloc;
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    _weatherBloc = BlocProvider.of<WeatherForSavedLocationsBloc>(context);
    _locationsBloc = BlocProvider.of<SaveLocationsBloc>(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _locationsBloc.add(GetSavedLocationsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Weader"),
        actions: <Widget>[
          SmallIconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SearchPage(),
                  ),
                );
              }),
          SmallIconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: buildBlocBuilder(),
    );
  }

  BlocBuilder<SaveLocationsBloc, SaveLocationsState> buildBlocBuilder() {
    return BlocBuilder<SaveLocationsBloc, SaveLocationsState>(
      builder: (context, state) {
        if (state is SaveLocationsLoading)
          return LoadingDisplay(message: "Loading saved locations");
        else if (state is SaveLocationsLoaded) {
          LocationsList locationsList = state.locationsList;
          List<LocationPosition> locationPositions = locationsList.locationsList
              .map((location) => LocationPosition(
                    latitude: location.latitude,
                    longitude: location.longitude,
                  ))
              .toList();
          _getWeather(locationPositions);
          return BlocBuilder<WeatherForSavedLocationsBloc,
              WeatherForSavedLocationsState>(
            builder: (context, state) {
              if (state is WeatherForSavedLocationsLoading)
                return LoadingDisplay(
                  message: "Fetching the weather forecasts",
                );
              if (state is WeatherForSavedLocationsLoaded)
                return BlocBuilder<SettingsBloc, SettingsState>(
                  builder: (context, settingsState) {
                    if (settingsState is SettingsLoaded) {
                      if (locationsList.locationsList.length > 0)
                        return WeatherForSavedLocationsDisplay(
                          weatherBloc: _weatherBloc,
                          locationPositions: locationPositions,
                          locationsList: locationsList,
                          saveLocationsBloc: _locationsBloc,
                          settingsLoadedState: settingsState,
                          weatherForSavedLocationsLoadedState: state,
                          context: context,
                          globalKey: _key,
                        );
                      else
                        return refreshButton();
                    } else if (settingsState is SettingsError)
                      showSnackBar(
                        context: context,
                        message: settingsState.message,
                      );
                    return refreshButton();
                  },
                );
              if (state is WeatherForSavedLocationsError)
                showSnackBar(context: context, message: state.message);
              return retryButton(
                "Couldn't fetch weather forecasts right now, please try again later",
                () => _getWeather(locationPositions),
              );
            },
          );
        } else if (state is SaveLocationsError)
          showSnackBar(context: context, message: state.message);
        return retryButton(
          "Couldn't fetch your list of saved locations, please try again later",
          _getSavedLocations,
        );
      },
    );
  }

  NoContentDisplay retryButton(
    String message,
    void Function() onPressed,
  ) =>
      NoContentDisplay(
        title: "Some error occured",
        message: message,
        action: OutlineButton(
          onPressed: onPressed,
          child: Text("Retry Now"),
        ),
      );

  NoContentDisplay refreshButton() => NoContentDisplay(
        title: "No saved locations found",
        message: "Save your favorite locations to see their weather right here",
        action: OutlineButton(
          onPressed: _getSavedLocations,
          child: Text("Refresh"),
        ),
      );

  void _getWeather(List<LocationPosition> locationPositions) =>
      _weatherBloc.add(GetWeatherForSavedLocationsEvent(locationPositions));

  void _getSavedLocations() => _locationsBloc.add(GetSavedLocationsEvent());

  @override
  void dispose() {
    super.dispose();
    _locationsBloc.add(GetSavedLocationsEvent());
  }
}
