import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

import '../entities/locations_list.dart';
import '../util/unique_id_generator.dart';
import 'location_model.dart';

class LocationsListModel extends LocationsList {
  LocationsListModel({
    @required List<LocationModel> locationsList,
  }) : super(
          locationsList: locationsList,
        );

  factory LocationsListModel.fromData(
      {List<Placemark> data, UniqueIdGenerator uniqueIdGenerator}) {
    List<LocationModel> _list = List<LocationModel>();

    _list = data
        .map((location) => LocationModel.fromData(
              data: location,
              uniqueIdGenerator: uniqueIdGenerator,
            ))
        .toList();

    return LocationsListModel(locationsList: _list);
  }

  factory LocationsListModel.fromJson(List json) {
    List<LocationModel> _list = List<LocationModel>();

    _list = json.map((i) => LocationModel.fromJson(i)).toList();
    return LocationsListModel(locationsList: _list);
  }

  List toJson() {
    List _list = List();

    locationsList.forEach(
      (i) => _list.add(
        {
          "id": i.id,
          "display_name": i.displayName,
          "address": i.address,
          "latitude": i.latitude,
          "longitude": i.longitude,
        },
      ),
    );

    return _list;
  }
}
