import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

import '../entities/entities.dart';
import '../util/unique_id_generator.dart';

class LocationModel extends Location {
  LocationModel({
    @required String address,
    @required String displayName,
    @required double latitude,
    @required double longitude,
    @required String id,
  }) : super(
          address: address,
          displayName: displayName,
          latitude: latitude,
          longitude: longitude,
          id: id,
        );

  factory LocationModel.fromData({
    Placemark data,
    UniqueIdGenerator uniqueIdGenerator,
  }) {
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
      id: uniqueIdGenerator.getId,
      address: _extractAddress(data),
      displayName: data.name,
      latitude: data.position.latitude,
      longitude: data.position.longitude,
    );
  }

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'],
      address: json['address'],
      displayName: json['display_name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "address": address,
      "display_name": displayName,
      "latitude": latitude,
      "longitude": longitude
    };
  }
}
