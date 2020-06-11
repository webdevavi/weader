import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/entities/location.dart';

@immutable
abstract class SaveLocationsEvent extends Equatable {
  SaveLocationsEvent();
}

class SaveLocationEvent extends SaveLocationsEvent {
  final Location location;

  SaveLocationEvent(this.location);
  @override
  List<Object> get props => [location];
}

class GetSavedLocationsEvent extends SaveLocationsEvent {
  @override
  List<Object> get props => [];
}

class DeleteSavedLocationEvent extends SaveLocationsEvent {
  final String id;

  DeleteSavedLocationEvent({@required this.id});
  @override
  List<Object> get props => [id];
}

class DeleteAllSavedLocationsEvent extends SaveLocationsEvent {
  @override
  List<Object> get props => [];
}
