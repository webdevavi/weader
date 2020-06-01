import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/locations_list.dart';

class LocationsListModel extends LocationsList {
  LocationsListModel({@required List<LocationModel> locationsList})
      : super(locationsList: locationsList);

  factory LocationsListModel.fromData(List<Placemark> data) {
    List<LocationModel> _list = List<LocationModel>();

    _list = data.map((location) => LocationModel.fromData(location)).toList();

    return LocationsListModel(locationsList: _list);
  }
}

class LocationModel extends Location {
  LocationModel({
    @required String address,
    @required String displayName,
    @required double latitude,
    @required double longitude,
  }) : super(
          address: address,
          displayName: displayName,
          latitude: latitude,
          longitude: longitude,
        );

  factory LocationModel.fromData(Placemark data) {
    List<String> _checkNullAndReturn(List<String> stringsList) {
      List<String> _list = List<String>();
      stringsList.forEach((string) {
        if (string != null && string.length > 0) _list.add(string);
      });
      return _list;
    }

    String _extractAddress(Placemark data) {
      List _list;

      List<String> strings = [
        data.subLocality,
        data.locality,
        data.subAdministrativeArea,
        data.administrativeArea,
        data.country,
      ];

      _list = _checkNullAndReturn(strings);

      return _list.join(", ");
    }

    return LocationModel(
        address: _extractAddress(data),
        displayName: data.name,
        latitude: data.position.latitude,
        longitude: data.position.longitude);
  }

  Map<String, dynamic> toJson() {
    return {
      "address": address,
      "display_name": displayName,
      "latitude": latitude,
      "longitude": longitude
    };
  }
}
