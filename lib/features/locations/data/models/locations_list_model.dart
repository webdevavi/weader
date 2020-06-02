import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/locations_list.dart';
import 'location_model.dart';

class LocationsListModel extends LocationsList {
  LocationsListModel({@required List<LocationModel> locationsList})
      : super(locationsList: locationsList);

  factory LocationsListModel.fromData(List<Placemark> data) {
    List<LocationModel> _list = List<LocationModel>();

    _list = data.map((location) => LocationModel.fromData(location)).toList();

    return LocationsListModel(locationsList: _list);
  }
}
