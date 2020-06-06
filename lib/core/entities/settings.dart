import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Settings extends Equatable {
  final UnitSystem unitSystem;
  final TimeFormat timeFormat;
  final DataPreference dataPreference;
  final CurrentTheme currentTheme;
  final Wallpaper wallpaper;

  Settings({
    @required this.unitSystem,
    @required this.timeFormat,
    @required this.dataPreference,
    @required this.currentTheme,
    @required this.wallpaper,
  });

  @override
  List<Object> get props => [
        unitSystem,
        timeFormat,
        dataPreference,
        currentTheme,
        wallpaper,
      ];
}

class UnitSystem extends Equatable {
  final bool isImperial;

  UnitSystem({@required this.isImperial});
  @override
  List<Object> get props => [isImperial];
}

class DataPreference extends Equatable {
  final bool isLocal;

  DataPreference({@required this.isLocal});
  @override
  List<Object> get props => [isLocal];
}

class TimeFormat extends Equatable {
  final bool is24Hours;

  TimeFormat({@required this.is24Hours});
  @override
  List<Object> get props => [is24Hours];
}

class CurrentTheme extends Equatable {
  final bool isDark;

  CurrentTheme({@required this.isDark});
  @override
  List<Object> get props => [isDark];
}

class Wallpaper extends Equatable {
  final bool isTimeAware;

  Wallpaper({@required this.isTimeAware});
  @override
  List<Object> get props => [isTimeAware];
}
