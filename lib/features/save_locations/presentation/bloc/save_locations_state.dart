import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/entities/entities.dart';

@immutable
abstract class SaveLocationsState extends Equatable {
  SaveLocationsState();
}

class SaveLocationsEmpty extends SaveLocationsState {
  @override
  List<Object> get props => [];
}

class SaveLocationsLoading extends SaveLocationsState {
  @override
  List<Object> get props => [];
}

class SaveLocationsLoaded extends SaveLocationsState {
  final LocationsList locationsList;

  SaveLocationsLoaded({@required this.locationsList});
  @override
  List<Object> get props => [locationsList];
}

class SaveLocationsError extends SaveLocationsState {
  final String message;

  SaveLocationsError({@required this.message});
  @override
  List<Object> get props => [message];
}
