import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../core/bottom_sheet/show_bottom_sheet.dart';
import '../../../../core/entities/entities.dart';
import '../../../../core/snack_bar/show_snack_bar.dart';
import '../../../save_locations/presentation/bloc/bloc.dart';
import '../../../settings/presentation/bloc/bloc.dart';
import '../../../weather_for_one_location/presentation/pages/weather_for_one_location_page.dart';
import '../../../weather_for_one_location/presentation/widgets/weather_widgets.dart';
import '../bloc/bloc.dart';

class WeatherForSavedLocationsDisplay extends StatelessWidget {
  const WeatherForSavedLocationsDisplay({
    Key key,
    @required WeatherForSavedLocationsBloc weatherBloc,
    @required SaveLocationsBloc saveLocationsBloc,
    @required this.locationPositions,
    @required this.locationsList,
    @required this.settingsLoadedState,
    @required this.weatherForSavedLocationsLoadedState,
    @required this.context,
    @required GlobalKey globalKey,
  })  : _weatherBloc = weatherBloc,
        _saveLocationsBloc = saveLocationsBloc,
        _key = globalKey,
        super(key: key);

  final WeatherForSavedLocationsBloc _weatherBloc;
  final SaveLocationsBloc _saveLocationsBloc;
  final List<LocationPosition> locationPositions;
  final LocationsList locationsList;
  final SettingsLoaded settingsLoadedState;
  final WeatherForSavedLocationsLoaded weatherForSavedLocationsLoadedState;
  final BuildContext context;
  final GlobalKey _key;

  @override
  Widget build(thisContext) {
    return RefreshIndicator(
      onRefresh: () async {
        _weatherBloc.add(GetWeatherForSavedLocationsEvent(locationPositions));
      },
      child: Column(
        children: <Widget>[
          SizedBox(height: 8.0),
          Expanded(
            child: ListView.builder(
              itemCount: locationsList.locationsList.length,
              itemBuilder: (thisContext, index) {
                FullWeather weather = weatherForSavedLocationsLoadedState
                    .fullWeatherList.fullWeatherList[index];
                Location location = locationsList.locationsList[index];
                return Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actions: <Widget>[
                          IconSlideAction(
                            icon: Icons.delete,
                            caption: "Delete",
                            color: Theme.of(context).errorColor,
                            onTap: () => _delete(
                              locationsList.locationsList[index].id,
                              context,
                              thisContext,
                            ),
                          ),
                        ],
                        secondaryActions: <Widget>[
                          IconSlideAction(
                            icon: Icons.arrow_forward,
                            caption: "Full Weather",
                            color: Theme.of(context).primaryColorDark,
                            onTap: () => _onTapForFullWeather(
                              thisContext,
                              location,
                            ),
                          ),
                        ],
                        child: CurrentWeatherDisplay(
                          location: location,
                          weather: weather,
                          settings: settingsLoadedState.settings,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.0)
                  ],
                );
              },
            ),
          ),
          FlatButton(
              onPressed: () => _deleteAll(context, thisContext),
              child: Text("Delete All")),
        ],
      ),
    );
  }

  void _delete(
    String id,
    BuildContext context,
    BuildContext thisContext,
  ) {
    showCustomBottomSheet(
      context: context,
      onClosing: () {},
      title: "Delete",
      subtitle: "This will delete the location from your saved locations list",
      actions: <Widget>[
        FlatButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(thisContext).pop();
          },
        ),
        FlatButton(
          child: const Text('Delete'),
          onPressed: () {
            Navigator.of(thisContext).pop(_saveLocationsBloc.add(
              DeleteSavedLocationEvent(
                id: id,
              ),
            ));
            showSnackBar(context: _key.currentContext, message: "Deleted");
          },
        )
      ],
    );
  }

  void _deleteAll(
    BuildContext context,
    BuildContext thisContext,
  ) {
    showCustomBottomSheet(
      context: context,
      onClosing: () {},
      title: "Delete All",
      subtitle:
          "This will delete all the locations from your saved locations list",
      actions: <Widget>[
        FlatButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(thisContext).pop();
          },
        ),
        FlatButton(
          child: const Text('Delete'),
          onPressed: () {
            Navigator.of(thisContext).pop(_saveLocationsBloc.add(
              DeleteAllSavedLocationsEvent(),
            ));
            showSnackBar(context: _key.currentContext, message: "Deleted All");
          },
        )
      ],
    );
  }

  void _onTapForFullWeather(
    BuildContext thisContext,
    Location location,
  ) async {
    final result = await Navigator.of(thisContext).push(
      MaterialPageRoute(
        builder: (_) => WeatherForOneLocationPage(
          location: location,
        ),
      ),
    );

    if (result != null) {
      showSnackBar(context: thisContext, message: result);
    }
  }
}
