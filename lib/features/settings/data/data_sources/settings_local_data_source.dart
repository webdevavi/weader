import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/settings/initial_settings.dart';
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
  Future<void> setSettings(SettingsModel settings);
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
  Future<void> setSettings(SettingsModel settings) async {
    final result = await sharedPreferences.setString(
      SETTINGS,
      json.encode(settings.toJson()),
    );
    if (result == false) throw UnexpectedException();
  }
}
