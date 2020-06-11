import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/models/locations_list_model.dart';

const SAVED_LOCATIONS_LIST = "SAVED_LOCATIONS_LIST";

abstract class SaveLocationsLocalDataSource {
  /// Saves locations list to local storage
  /// and returns the saved locations list
  ///
  /// Throws a [UnexpectedException] if saving fails.
  Future<void> saveLocation(LocationsListModel locationsList);

  /// Gets the lcoations list from local storage which was saved by user
  ///
  /// Throws a [NoLocalDataException] for all exceptions
  Future<LocationsListModel> getSavedLocationsList();

  /// Deletes one location from the saved locations list
  /// and then return the new locations list
  ///
  /// Throws a [UnexpectedException] if deleting fails
  /// Throws a [NoLocalDataException] for all exception
  Future<LocationsListModel> deleteSavedLocation(String id);

  /// Deletes all the saved locations list
  ///
  /// Throws a [UnexpectedException] if deleting fails
  /// Throws a [NoLocalDataException] for all exception
  Future<void> deleteAllSavedLocations();
}

class SaveLocationsLocalDataSourceImpl implements SaveLocationsLocalDataSource {
  final SharedPreferences sharedPreferences;

  SaveLocationsLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<void> saveLocation(LocationsListModel locationsList) async {
    final result = await sharedPreferences.setString(
        SAVED_LOCATIONS_LIST, json.encode(locationsList.toJson()));
    if (result == false) throw UnexpectedException();
  }

  @override
  Future<LocationsListModel> getSavedLocationsList() {
    try {
      final jsonString = sharedPreferences.getString(SAVED_LOCATIONS_LIST);
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
  Future<void> deleteAllSavedLocations() async {
    final result = await sharedPreferences.remove(SAVED_LOCATIONS_LIST);
    if (result == false) throw UnexpectedException();
  }

  @override
  Future<LocationsListModel> deleteSavedLocation(String id) async {
    final recentlySearchedLocationsList = sharedPreferences.getString(
      SAVED_LOCATIONS_LIST,
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
        SAVED_LOCATIONS_LIST,
        json.encode(
          locationsListModel.toJson(),
        ),
      );

      if (result == false) throw UnexpectedException();

      return Future.value(locationsListModel);
    } else
      throw NoLocalDataException();
  }
}
