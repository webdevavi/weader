import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../core/bottom_sheet/show_bottom_sheet.dart';
import '../../../../core/entities/entities.dart';
import '../../../../core/snack_bar/show_snack_bar.dart';
import '../../../../core/widgets/no_content_display.dart';
import '../../../weather_for_one_location/presentation/pages/weather_for_one_location_page.dart';
import '../bloc/bloc.dart';

class SearchLocationsListDisplay extends StatefulWidget {
  final List<Location> locationsList;
  final bool recents;
  final BuildContext mainContext;

  const SearchLocationsListDisplay({
    Key key,
    this.locationsList,
    @required this.recents,
    @required this.mainContext,
  }) : super(key: key);

  @override
  _SearchLocationsListDisplayState createState() =>
      _SearchLocationsListDisplayState();
}

class _SearchLocationsListDisplayState
    extends State<SearchLocationsListDisplay> {
  SearchLocationsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<SearchLocationsBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.locationsList != null && widget.locationsList.length > 0)
      return ListView.separated(
          separatorBuilder: (context, index) => Divider(height: 0),
          itemCount: widget.locationsList.length,
          itemBuilder: (context, index) {
            return Slidable(
              key: Key(widget.locationsList[index].id),
              actionPane: SlidableDrawerActionPane(),
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'Clear',
                  color: Theme.of(context).primaryColor,
                  icon: Icons.clear,
                  onTap: () => _onClear(index, widget.mainContext),
                ),
              ],
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 4.0,
                  horizontal: 8.0,
                ),
                onTap: () => _navigateToWeatherPage(context, index),
                onLongPress: () {},
                leading: _showLeadingIcon(),
                title: Text(widget.locationsList[index].displayName),
                subtitle: Text(widget.locationsList[index].address),
                trailing: Icon(Icons.arrow_forward),
              ),
            );
          });
    else {
      return NoContentDisplay(
        title: "No recent searches",
        message:
            "You might have cleared all your recent searches if not searched anything at all",
      );
    }
  }

  Icon _showLeadingIcon() {
    if (widget.recents)
      return Icon(Icons.access_time);
    else
      return Icon(Icons.search);
  }

  void _navigateToWeatherPage(
    BuildContext context,
    int index,
  ) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WeatherForOneLocationPage(
          location: widget.locationsList[index],
        ),
      ),
    );

    if (result != null) {
      showSnackBar(context: context, message: result);
    }
  }

  void _onClear(index, mainContext) {
    showCustomBottomSheet(
      context: context,
      onClosing: () {},
      title: "Clear",
      subtitle: "This will clear this search from your recent searched",
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
            Navigator.of(context).pop(_bloc.add(
              ClearOneRecentlySearchedLocationEvent(
                id: widget.locationsList[index].id,
              ),
            ));
            showSnackBar(context: mainContext, message: "Cleared");
          },
        )
      ],
    );
  }
}
