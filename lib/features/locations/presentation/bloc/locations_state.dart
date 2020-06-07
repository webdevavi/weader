import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/locations_list.dart';

@immutable
abstract class LocationsState extends Equatable {
  LocationsState();
}

class LocationsEmpty extends LocationsState {
  @override
  List<Object> get props => [];
}

class LocationsLoading extends LocationsState {
  @override
  List<Object> get props => [];
}

class LocationsLoaded extends LocationsState {
  final LocationsList locationsList;

  LocationsLoaded({@required this.locationsList});
  @override
  List<Object> get props => [locationsList];
}

class LocationsRecentlySearched extends LocationsState {
  final LocationsList recentlySearchedLocationsList;

  LocationsRecentlySearched({@required this.recentlySearchedLocationsList});
  @override
  List<Object> get props => [recentlySearchedLocationsList];
}

class LocationsRecentlySearchedCleared extends LocationsState {
  final bool locationsRecentlySearchedCleared;

  LocationsRecentlySearchedCleared({this.locationsRecentlySearchedCleared});
  @override
  List<Object> get props => [locationsRecentlySearchedCleared];
}

class LocationsError extends LocationsState {
  final String message;

  LocationsError({@required this.message});
  @override
  List<Object> get props => [message];
}
