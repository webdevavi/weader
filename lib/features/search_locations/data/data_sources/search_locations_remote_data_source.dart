import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/models/locations_list_model.dart';
import '../../../../core/util/unique_id_generator.dart';

abstract class SearchLocationsRemoteDataSource {
  /// Calls the geolocator package.
  ///
  /// Throws a [NotFoundException] for all error codes.
  Future<LocationsListModel> getLocationsList(String queryString);
}

class SearchLocationsRemoteDataSourceImpl
    implements SearchLocationsRemoteDataSource {
  final Geolocator geolocator;
  final UniqueIdGenerator uniqueIdGenerator;

  SearchLocationsRemoteDataSourceImpl({
    @required this.geolocator,
    @required this.uniqueIdGenerator,
  });

  @override
  Future<LocationsListModel> getLocationsList(String queryString) async {
    try {
      final placemarks = await geolocator.placemarkFromAddress(queryString);
      if (placemarks != null)
        return LocationsListModel.fromData(
          data: placemarks,
          uniqueIdGenerator: uniqueIdGenerator,
        );
      else
        throw NotFoundException();
    } on Exception {
      throw NotFoundException();
    }
  }
}
