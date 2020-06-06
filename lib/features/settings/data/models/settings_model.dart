import 'package:meta/meta.dart';

import '../../../../core/entities/settings.dart';

class SettingsModel extends Settings {
  final UnitSystem unitSystem;
  final TimeFormat timeFormat;
  final DataPreference dataPreference;
  final CurrentTheme currentTheme;
  final Wallpaper wallpaper;

  SettingsModel({
    @required this.unitSystem,
    @required this.timeFormat,
    @required this.dataPreference,
    @required this.currentTheme,
    @required this.wallpaper,
  }) : super(
          unitSystem: unitSystem,
          timeFormat: timeFormat,
          dataPreference: dataPreference,
          currentTheme: currentTheme,
          wallpaper: wallpaper,
        );

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      unitSystem: UnitSystem(
        isImperial: json['unit_system_is_imperial'],
      ),
      timeFormat: TimeFormat(
        is24Hours: json['time_format_is_24_hours'],
      ),
      dataPreference: DataPreference(
        isLocal: json['data_preference_is_local'],
      ),
      currentTheme: CurrentTheme(
        isDark: json['current_theme_is_dark'],
      ),
      wallpaper: Wallpaper(isTimeAware: json['wallpaper_is_time_aware']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "unit_system_is_imperial": unitSystem.isImperial,
      "time_format_is_24_hours": timeFormat.is24Hours,
      "data_preference_is_local": dataPreference.isLocal,
      "current_theme_is_dark": currentTheme.isDark,
      "wallpaper_is_time_aware": wallpaper.isTimeAware,
    };
  }
}
