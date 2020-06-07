import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../injector.dart';
import '../bloc/bloc.dart';
import '../widgets/locations_widgets.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LocationsBloc>(),
      child: StatefulSearchPage(),
    );
  }
}

class StatefulSearchPage extends StatefulWidget {
  @override
  _StatefulSearchPageState createState() => _StatefulSearchPageState();
}

class _StatefulSearchPageState extends State<StatefulSearchPage> {
  String query;
  TextEditingController controller = TextEditingController();
  FocusNode focus = FocusNode();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<LocationsBloc>(context).add(
      GetRecentlySearchedLocationsListEvent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SafeArea(
          child: BackButton(),
        ),
        titleSpacing: 0.0,
        title: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: Material(
              color: Theme.of(context).primaryColorDark,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: controller,
                      focusNode: focus,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 18.0),
                        border: InputBorder.none,
                        hintText: "Search",
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                      cursorColor: Colors.white,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                      onChanged: (value) => setState(() {
                        query = value;
                      }),
                      onSubmitted: (_) => _addGetLocations(query),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    color: Colors.white,
                    onPressed: () => _addGetLocations(query),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        query = null;
                      });
                      controller.clear();
                    },
                    color: Colors.white,
                    icon: Icon(Icons.clear),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<LocationsBloc, LocationsState>(
        builder: (context, state) {
          if (state is LocationsEmpty) {
            return Container();
          } else if (state is LocationsLoading) {
            return LinearProgressIndicator();
          } else if (state is LocationsRecentlySearched) {
            return LocationsListDisplay(
              locationsList: state
                  .recentlySearchedLocationsList.locationsList.reversed
                  .toList(),
              recents: true,
              error: false,
            );
          } else if (state is LocationsRecentlySearchedCleared) {
            if (state.locationsRecentlySearchedCleared == true)
              return LocationsListDisplay(
                recents: false,
                error: false,
              );
            else {
              BlocProvider.of<LocationsBloc>(context).add(
                GetRecentlySearchedLocationsListEvent(),
              );
            }
          } else if (state is LocationsLoaded) {
            return LocationsListDisplay(
              locationsList: state.locationsList.locationsList,
              recents: false,
              error: false,
            );
          } else if (state is LocationsError) {
            return LocationsListDisplay(
              recents: false,
              error: true,
              errorMessage: state.message,
            );
          }
          return Container();
        },
      ),
    );
  }

  void _addGetLocations(String query) {
    focus.unfocus();
    BlocProvider.of<LocationsBloc>(context).add(GetLocationsListEvent(query));
  }
}
