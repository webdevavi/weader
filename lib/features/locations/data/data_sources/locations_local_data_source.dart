import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weader/core/error/exception.dart';

import '../models/locations_list_model.dart';

const RECENTLY_SEARCHED_LOCATIONS_LIST = "RECENTLY_SEARCHED_LOCATIONS_LIST";

abstract class LocationsLocalDataSource {
  /// Gets the data from local storage which was saved
  /// when the user had searched for a location last time
  ///
  /// Throws a [NoLocalDataException] for all exceptions
  Future<LocationsListModel> getRecentlySearchedLocationsList();

  /// Sets the recently searched locations list to local storage
  Future<void> setRecentlySearchedLocationsList(
    LocationsListModel locationsList,
  );

  /// Sets the data after removing one location with passed id
  ///
  /// Throws a [NoLocalDataException] for all exception
  Future<LocationsListModel> clearOneRecentlySearchedLocation(String id);

  /// Sets the data after removing one location with passed id
  ///
  /// Throws a [UnexpectedException] for all exception
  Future<bool> clearAllRecentlySearchedLocation();
}

class LocationsLocalDataSourceImpl implements LocationsLocalDataSource {
  final SharedPreferences sharedPreferences;

  LocationsLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<LocationsListModel> getRecentlySearchedLocationsList() {
    try {
      final jsonString = sharedPreferences.getString(
        RECENTLY_SEARCHED_LOCATIONS_LIST,
      );
      if (jsonString != null)
        return Future.value(
            LocationsListModel.fromJson(json.decode(jsonString)));
      else
        throw NoLocalDataException();
    } on Exception {
      throw NoLocalDataException();
    }
  }

  @override
  Future<void> setRecentlySearchedLocationsList(
      LocationsListModel locationsList) {
    return sharedPreferences.setString(
        RECENTLY_SEARCHED_LOCATIONS_LIST, json.encode(locationsList.toJson()));
  }

  @override
  Future<LocationsListModel> clearOneRecentlySearchedLocation(String id) {
    final recentlySearchedLocationsList = sharedPreferences.getString(
      RECENTLY_SEARCHED_LOCATIONS_LIST,
    );

    if (recentlySearchedLocationsList != null) {
      final locationsListModel = LocationsListModel.fromJson(
        json.decode(
          recentlySearchedLocationsList,
        ),
      );

      locationsListModel.locationsList.removeWhere(
        (location) => location.id == id,
      );

      sharedPreferences.setString(
        RECENTLY_SEARCHED_LOCATIONS_LIST,
        json.encode(
          locationsListModel.toJson(),
        ),
      );

      return Future.value(locationsListModel);
    } else
      throw NoLocalDataException();
  }

  @override
  Future<bool> clearAllRecentlySearchedLocation() async {
    return await sharedPreferences.remove(RECENTLY_SEARCHED_LOCATIONS_LIST);
  }
}
