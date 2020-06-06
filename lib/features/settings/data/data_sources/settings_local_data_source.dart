import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weader/core/error/exception.dart';
import 'package:weader/core/settings/initial_settings.dart';

import '../models/settings_model.dart';

const SETTINGS = "SETTINGS";

abstract class SettingsLocalDataSource {
  /// Gets the [SettingsModel] from local storage
  ///
  /// Returens [initialSettings] if no settings data is present
  ///
  /// Throws [UnexpectedException] for any exception
  Future<SettingsModel> getSettings();

  /// Sets the [SettingsModel] to local storage
  ///
  /// Throws [UnexpectedException] for any exception
  Future<SettingsModel> setSettings(SettingsModel settings);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences sharedPreferences;

  SettingsLocalDataSourceImpl({@required this.sharedPreferences});
  @override
  Future<SettingsModel> getSettings() {
    try {
      final jsonString = sharedPreferences.getString(SETTINGS);
      if (jsonString != null)
        return Future.value(SettingsModel.fromJson(json.decode(jsonString)));
      else
        return Future.value(initialSettings);
    } on Exception {
      throw UnexpectedException();
    }
  }

  @override
  Future<SettingsModel> setSettings(SettingsModel settings) {
    try {
      sharedPreferences.setString(SETTINGS, json.encode(settings.toJson()));
      return Future.value(settings);
    } on Exception {
      throw UnexpectedException();
    }
  }
}
