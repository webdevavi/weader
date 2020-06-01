import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/locations_list.dart';

@immutable
abstract class LocationsState extends Equatable {
  LocationsState();
}

class Empty extends LocationsState {
  @override
  List<Object> get props => [];
}

class Loading extends LocationsState {
  @override
  List<Object> get props => [];
}

class Loaded extends LocationsState {
  final LocationsList locationsList;

  Loaded({@required this.locationsList});
  @override
  List<Object> get props => [locationsList];
}

class Error extends LocationsState {
  final String message;

  Error({@required this.message});
  @override
  List<Object> get props => [message];
}
