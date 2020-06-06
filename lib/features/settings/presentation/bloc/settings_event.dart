import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:weader/core/entities/settings.dart';

@immutable
abstract class SettingsEvent extends Equatable {
  SettingsEvent();
}

class GetSettingsEvent extends SettingsEvent {
  @override
  List<Object> get props => [];
}

class SetSettingsEvent extends SettingsEvent {
  final Settings settings;

  SetSettingsEvent(this.settings);

  @override
  List<Object> get props => [settings];
}
