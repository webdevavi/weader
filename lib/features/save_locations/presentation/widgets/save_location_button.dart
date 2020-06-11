import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/bottom_sheet/show_bottom_sheet.dart';
import '../../../../core/entities/entities.dart';
import '../../../../core/snack_bar/show_snack_bar.dart';
import '../../../../core/widgets/widgets.dart';
import '../bloc/bloc.dart';

class SaveLocationButton extends StatefulWidget {
  final Location location;

  const SaveLocationButton({Key key, this.location}) : super(key: key);
  @override
  _SaveLocationButtonState createState() => _SaveLocationButtonState();
}

class _SaveLocationButtonState extends State<SaveLocationButton> {
  SaveLocationsBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<SaveLocationsBloc>(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<SaveLocationsBloc>(context).add(GetSavedLocationsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SaveLocationsBloc, SaveLocationsState>(
        builder: (context, state) {
      if (state is SaveLocationsLoading)
        return SmallIconButton(
          onPressed: () {},
          icon: Icon(Icons.add_circle_outline),
        );
      if (state is SaveLocationsLoaded) {
        List<Location> locationsList = state.locationsList.locationsList;
        if (locationsList.length > 0 &&
            (locationsList.singleWhere(
                    (savedLocation) =>
                        savedLocation.latitude == widget.location.latitude &&
                        savedLocation.longitude == widget.location.longitude,
                    orElse: () => null)) !=
                null) {
          return SmallIconButton(
            onPressed: _showDeleteDialog,
            icon: Icon(Icons.add_circle),
          );
        } else
          return SmallIconButton(
            onPressed: _saveLocation,
            icon: Icon(Icons.add_circle_outline),
          );
      }
      return Container();
    });
  }

  void _showDeleteDialog() {
    showCustomBottomSheet(
      context: context,
      onClosing: () {},
      title: "Delete",
      subtitle: "This will delete this location from your saved locations list",
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Cancel"),
        ),
        FlatButton(
          onPressed: () => Navigator.of(context).pop(
            _deleteLocation(),
          ),
          child: Text("Delete"),
        ),
      ],
    );
  }

  void _saveLocation() {
    bloc.add(
      SaveLocationEvent(
        widget.location,
      ),
    );
    showSnackBar(context: context, message: "Locations saved");
  }

  void _deleteLocation() {
    bloc.add(
      DeleteSavedLocationEvent(id: widget.location.id),
    );
    showSnackBar(context: context, message: "Locations Deleted");
  }
}
