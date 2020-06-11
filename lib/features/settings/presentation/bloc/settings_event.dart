import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/entities/settings.dart';

@immutable
abstract class SettingsEvent extends Equatable {
  SettingsEvent();
}

class GetSettingsEvent extends SettingsEvent {
  @override
  List<Object> get props => [];
}

class SwitchUnitSystemEvent extends SettingsEvent {
  final UnitSystem unitSystem;

  SwitchUnitSystemEvent(this.unitSystem);

  @override
  List<Object> get props => [unitSystem];
}

class SwitchTimeFormatEvent extends SettingsEvent {
  final TimeFormat timeFormat;

  SwitchTimeFormatEvent(this.timeFormat);

  @override
  List<Object> get props => [timeFormat];
}

class SwitchDataPreferenceEvent extends SettingsEvent {
  final DataPreference dataPreference;

  SwitchDataPreferenceEvent(this.dataPreference);

  @override
  List<Object> get props => [dataPreference];
}

class SwitchCurrentThemeEvent extends SettingsEvent {
  final CurrentTheme currentTheme;

  SwitchCurrentThemeEvent(this.currentTheme);

  @override
  List<Object> get props => [currentTheme];
}

class SwitchWallpaperEvent extends SettingsEvent {
  final Wallpaper wallpaper;

  SwitchWallpaperEvent(this.wallpaper);

  @override
  List<Object> get props => [wallpaper];
}
