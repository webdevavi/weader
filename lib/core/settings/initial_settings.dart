import '../../features/settings/data/models/settings_model.dart';
import '../entities/settings.dart';

final initialSettings = SettingsModel(
  unitSystem: UnitSystem(
    isImperial: false,
  ),
  timeFormat: TimeFormat(
    is24Hours: false,
  ),
  dataPreference: DataPreference(
    isLocal: false,
  ),
  currentTheme: CurrentTheme(
    isDark: false,
  ),
  wallpaper: Wallpaper(
    isTimeAware: true,
  ),
);
