import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/models/locations_list_model.dart';

const RECENTLY_SEARCHED_LOCATIONS_LIST = "RECENTLY_SEARCHED_LOCATIONS_LIST";
const SAVED_LOCATIONS_LIST = "SAVED_LOCATIONS_LIST";

abstract class SearchLocationsLocalDataSource {
  /// Gets the data from local storage which was saved
  /// when the user had searched for a location last time
  ///
  /// Throws a [NoLocalDataException] for all exceptions
  Future<LocationsListModel> getRecentlySearchedLocationsList();

  /// Sets the recently searched locations list to local storage
  Future<void> setRecentlySearchedLocationsList(
    LocationsListModel locationsList,
  );

  /// Deletes one location from the saved recently searched locations list
  /// and then returns the new locations list
  ///
  /// Throws a [UnexpectedException] if clearing fails.
  /// Throws a [NoLocalDataException] for all exception
  Future<LocationsListModel> clearOneRecentlySearchedLocation(String id);

  /// Deletes all the saved recently searched locations list
  ///
  /// Throws a [UnexpectedException] for all exception
  Future<void> clearAllRecentlySearchedLocation();
}

class SearchLocationsLocalDataSourceImpl
    implements SearchLocationsLocalDataSource {
  final SharedPreferences sharedPreferences;

  SearchLocationsLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<LocationsListModel> getRecentlySearchedLocationsList() {
    try {
      final jsonString =
          sharedPreferences.getString(RECENTLY_SEARCHED_LOCATIONS_LIST);
      if (jsonString == null)
        return Future.value(
          LocationsListModel(locationsList: []),
        );

      return Future.value(LocationsListModel.fromJson(json.decode(jsonString)));
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
  Future<LocationsListModel> clearOneRecentlySearchedLocation(String id) async {
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

      final result = await sharedPreferences.setString(
        RECENTLY_SEARCHED_LOCATIONS_LIST,
        json.encode(
          locationsListModel.toJson(),
        ),
      );

      if (result == false) throw UnexpectedException();

      return Future.value(locationsListModel);
    } else
      throw NoLocalDataException();
  }

  @override
  Future<void> clearAllRecentlySearchedLocation() async {
    final result =
        await sharedPreferences.remove(RECENTLY_SEARCHED_LOCATIONS_LIST);
    if (result == false) throw UnexpectedException();
  }
}
