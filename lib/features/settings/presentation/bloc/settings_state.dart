import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/entities/settings.dart';

@immutable
abstract class SettingsState extends Equatable {
  SettingsState();
}

class SettingsLoading extends SettingsState {
  @override
  List<Object> get props => [];
}

class SettingsLoaded extends SettingsState {
  final Settings settings;

  SettingsLoaded({@required this.settings});
  @override
  List<Object> get props => [settings];
}

class SettingsError extends SettingsState {
  final String message;

  SettingsError({@required this.message});
  @override
  List<Object> get props => [message];
}
