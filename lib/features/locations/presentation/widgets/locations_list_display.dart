import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weader/core/widgets/error_display.dart';
import 'package:weader/features/locations/presentation/bloc/bloc.dart';
import 'package:weader/features/locations/presentation/bloc/locations_event.dart';
import 'package:weader/features/weather/presentation/pages/weather_pages.dart';

class LocationsListDisplay extends StatelessWidget {
  final List locationsList;
  final bool error;
  final bool recents;
  final String errorMessage;

  const LocationsListDisplay({
    Key key,
    this.locationsList,
    @required this.recents,
    this.errorMessage,
    @required this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Icon showLeadingIcon() {
      if (recents)
        return Icon(Icons.access_time);
      else
        return Icon(Icons.search);
    }

    FlatButton showClearAllButton() {
      if (recents)
        return FlatButton(
          onPressed: () {
            BlocProvider.of<LocationsBloc>(context).add(
              ClearAllRecentlySearchedLocationsListEvent(),
            );
          },
          child: Text("Clear all"),
        );
      else
        return FlatButton(
          onPressed: () {
            BlocProvider.of<LocationsBloc>(context).add(
              GetRecentlySearchedLocationsListEvent(),
            );
          },
          child: Text("Recent Searches"),
        );
    }

    Expanded showContent() {
      if (locationsList != null)
        return Expanded(
          child: ListView.builder(
              itemCount: locationsList.length,
              itemBuilder: (context, index) {
                return Column(
                  children: <Widget>[
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 4.0,
                        horizontal: 8.0,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WeatherPage(
                              location: locationsList[index],
                            ),
                          ),
                        );
                      },
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              title: Text("Clear"),
                              content: Text(
                                "This will delete the search from recents",
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: const Text('CANCEL'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                FlatButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop(
                                        BlocProvider.of<LocationsBloc>(context)
                                            .add(
                                      ClearOneRecentlySearchedLocationEvent(
                                        id: locationsList[index].id,
                                      ),
                                    ));
                                  },
                                )
                              ],
                            );
                          },
                        );
                      },
                      leading: showLeadingIcon(),
                      title: Text(
                        locationsList[index].displayName,
                      ),
                      subtitle: Text(
                        locationsList[index].address,
                      ),
                      trailing: Icon(Icons.arrow_forward),
                    ),
                    Divider(
                      height: 0,
                    ),
                  ],
                );
              }),
        );
      else if (error)
        return Expanded(
          child: ErrorDisplay(
            message: errorMessage,
          ),
        );
      else
        return Expanded(
          child: Center(
            child: Text(
              "No recent searches",
              textAlign: TextAlign.center,
            ),
          ),
        );
    }

    return Column(
      children: <Widget>[
        showContent(),
        showClearAllButton(),
      ],
    );
  }
}
