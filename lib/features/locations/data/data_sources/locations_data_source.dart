import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:weader/core/error/exception.dart';

import '../models/locations_list_model.dart';

abstract class LocationsDataSource {
  /// Calls the geolocator package.
  ///
  /// Throws a [NotFoundException] for all error codes.
  Future<LocationsListModel> getLocationsList(String queryString);

  /// Calls the geolocator package.
  ///
  /// Throws a [DeviceLocationException, NotFoundException] for all error codes.
  Future<LocationsListModel> getDeviceLocationsList();
}

class LocationsDataSourceImpl implements LocationsDataSource {
  final Geolocator geolocator;

  LocationsDataSourceImpl({@required this.geolocator});
  @override
  Future<LocationsListModel> getDeviceLocationsList() async {
    final position = await geolocator.getCurrentPosition();
    if (position != null) {
      final placemarks = await geolocator.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks != null)
        return LocationsListModel.fromData(placemarks);
      else
        throw NotFoundException();
    } else
      throw DeviceLocationException();
  }

  @override
  Future<LocationsListModel> getLocationsList(String queryString) async {
    try {
      final placemarks = await geolocator.placemarkFromAddress(queryString);
      if (placemarks != null)
        return LocationsListModel.fromData(placemarks);
      else
        throw NotFoundException();
    } on Exception {
      throw NotFoundException();
    }
  }
}
