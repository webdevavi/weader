import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/bottom_sheet/show_bottom_sheet.dart';
import '../../../../core/snack_bar/show_snack_bar.dart';
import '../bloc/bloc.dart';
import 'search_locations_list_display.dart';

class SearchPageBody extends StatelessWidget {
  final SearchLocationsBloc bloc;
  final BuildContext mainContext;
  final GlobalKey globalKey;

  const SearchPageBody({
    Key key,
    @required this.bloc,
    @required this.mainContext,
    @required this.globalKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List recentSearches;

    return BlocBuilder<SearchLocationsBloc, SearchLocationsState>(
      builder: (context, state) {
        if (state is SearchLocationsEmpty)
          return Container();
        else if (state is SearchLocationsLoading)
          return LinearProgressIndicator(
            backgroundColor: Colors.grey[800],
          );
        else if (state is RecentlySearchedLocationsLoaded) {
          recentSearches = state
              .recentlySearchedLocationsList.locationsList.reversed
              .toList();
          return Column(
            children: <Widget>[
              Expanded(
                child: SearchLocationsListDisplay(
                  locationsList: recentSearches,
                  recents: true,
                  mainContext: mainContext,
                ),
              ),
              FlatButton(
                onPressed: () => _onClearAll(recentSearches, context),
                child: Text("Clear all"),
              ),
            ],
          );
        } else if (state is SearchLocationsLoaded)
          return Column(
            children: <Widget>[
              Expanded(
                child: SearchLocationsListDisplay(
                  locationsList: state.locationsList.locationsList,
                  recents: false,
                  mainContext: mainContext,
                ),
              ),
              FlatButton(
                onPressed: () {
                  bloc.add(
                    GetRecentlySearchedLocationsListEvent(),
                  );
                },
                child: Text("Recent Searches"),
              ),
            ],
          );
        else if (state is SearchLocationsError) {
          showSnackBar(context: context, message: state.message);
          return Column(
            children: <Widget>[
              Expanded(
                child: SearchLocationsListDisplay(
                  locationsList: recentSearches,
                  recents: true,
                  mainContext: mainContext,
                ),
              ),
              FlatButton(
                onPressed: () => _onClearAll(recentSearches, context),
                child: Text("Clear all"),
              ),
            ],
          );
        }

        return Container();
      },
    );
  }

  void _onClearAll(List recentSearches, BuildContext context) {
    if (recentSearches.length > 0)
      showCustomBottomSheet(
        context: context,
        onClosing: () {},
        title: "Clear All",
        subtitle: "This will clear all the recent searches",
        actions: <Widget>[
          FlatButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: const Text('Clear'),
            onPressed: () {
              Navigator.of(context).pop(bloc.add(
                ClearAllRecentlySearchedLocationsListEvent(),
              ));
              showSnackBar(
                  context: globalKey.currentContext, message: "Cleared All");
            },
          )
        ],
      );
    else
      showSnackBar(
          context: globalKey.currentContext, message: "Nothing to clear");
  }
}
