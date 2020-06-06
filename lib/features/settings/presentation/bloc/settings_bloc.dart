import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:weader/core/entities/settings.dart';
import 'package:weader/core/error/failures.dart';
import 'package:weader/core/settings/initial_settings.dart';
import '../../../../core/usecases/usecase.dart';

import './bloc.dart';
import '../../domain/usecases/get_settings.dart';
import '../../domain/usecases/set_settings.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetSettings getSettings;
  final SetSettings setSettings;

  SettingsBloc({
    @required this.getSettings,
    @required this.setSettings,
  })  : assert(getSettings != null),
        assert(setSettings != null);

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
    } else if (event is SetSettingsEvent) {
      final settingsEither =
          await setSettings(Params(settings: event.settings));
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
