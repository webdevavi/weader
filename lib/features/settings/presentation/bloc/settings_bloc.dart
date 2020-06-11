import 'dart:async';

import 'package:Weader/features/settings/domain/usecases/switch_current_theme.dart';
import 'package:Weader/features/settings/domain/usecases/switch_data_preference.dart';
import 'package:Weader/features/settings/domain/usecases/switch_time_format.dart';
import 'package:Weader/features/settings/domain/usecases/switch_unit_system.dart';
import 'package:Weader/features/settings/domain/usecases/switch_wallpaper.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import './bloc.dart';
import '../../../../core/entities/settings.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/settings/initial_settings.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_settings.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetSettings getSettings;
  final SwitchUnitSystem switchUnitSystem;
  final SwitchTimeFormat switchTimeFormat;
  final SwitchDataPreference switchDataPreference;
  final SwitchCurrentTheme switchCurrentTheme;
  final SwitchWallpaper switchWallpaper;

  SettingsBloc({
    @required this.getSettings,
    @required this.switchCurrentTheme,
    @required this.switchDataPreference,
    @required this.switchTimeFormat,
    @required this.switchUnitSystem,
    @required this.switchWallpaper,
  })  : assert(getSettings != null),
        assert(switchDataPreference != null),
        assert(switchTimeFormat != null),
        assert(switchUnitSystem != null),
        assert(switchWallpaper != null),
        assert(switchCurrentTheme != null);

  @override
  SettingsState get initialState => SettingsLoaded(
        settings: initialSettings,
      );

  @override
  Stream<SettingsState> mapEventToState(
    SettingsEvent event,
  ) async* {
    if (event is GetSettingsEvent) {
      final settingsEither = await getSettings(NoParams());

      yield* failureOrSettings(settingsEither);
    } else if (event is SwitchUnitSystemEvent) {
      final settingsEither =
          await switchUnitSystem(SwitchUnitSystemParams(event.unitSystem));
      yield* failureOrSettings(settingsEither);
    } else if (event is SwitchTimeFormatEvent) {
      final settingsEither =
          await switchTimeFormat(SwitchTimeFormatParams(event.timeFormat));
      yield* failureOrSettings(settingsEither);
    } else if (event is SwitchDataPreferenceEvent) {
      final settingsEither =
          await switchDataPreference(SwitchDataPreferenceParams(
        event.dataPreference,
      ));
      yield* failureOrSettings(settingsEither);
    } else if (event is SwitchCurrentThemeEvent) {
      final settingsEither = await switchCurrentTheme(
        SwitchCurrentThemeParams(event.currentTheme),
      );
      yield* failureOrSettings(settingsEither);
    } else if (event is SwitchWallpaperEvent) {
      final settingsEither =
          await switchWallpaper(SwitchWallpaperParams(event.wallpaper));
      yield* failureOrSettings(settingsEither);
    }
  }

  Stream<SettingsState> failureOrSettings(
      Either<Failure, Settings> settingsEither) {
    return settingsEither.fold((failure) async* {
      yield SettingsError(message: mapFailureToMessage(failure));
    }, (settings) async* {
      yield SettingsLoaded(settings: settings);
    });
  }
}
