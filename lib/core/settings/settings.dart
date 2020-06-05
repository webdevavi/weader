enum Unit {
  METRIC,
  IMPERIAL,
}

enum TimeFormat {
  HOURS24,
  HOURS12,
}

enum DataPreference {
  LOCAL,
  TIMEZONE_SPECIFIC,
}

enum CurrentTheme {
  LIGHT,
  DARK,
}

enum Wallpaper {
  COLOR,
  TIME_AWARE,
}

class Settings {
  final Unit unit = Unit.METRIC;
  final TimeFormat timeFormat = TimeFormat.HOURS12;
  final DataPreference dataPreference = DataPreference.TIMEZONE_SPECIFIC;
  final CurrentTheme theme = CurrentTheme.LIGHT;
  final Wallpaper wallpaper = Wallpaper.TIME_AWARE;
}
