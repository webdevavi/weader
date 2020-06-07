import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LocationsEvent extends Equatable {
  LocationsEvent();
}

class GetLocationsListEvent extends LocationsEvent {
  final String queryString;

  GetLocationsListEvent(this.queryString);
  @override
  List<Object> get props => [queryString];
}

class GetDeviceLocationsListEvent extends LocationsEvent {
  @override
  List<Object> get props => [];
}

class GetRecentlySearchedLocationsListEvent extends LocationsEvent {
  @override
  List<Object> get props => [];
}

class ClearOneRecentlySearchedLocationEvent extends LocationsEvent {
  final String id;

  ClearOneRecentlySearchedLocationEvent({@required this.id});
  @override
  List<Object> get props => [];
}

class ClearAllRecentlySearchedLocationsListEvent extends LocationsEvent {
  @override
  List<Object> get props => [];
}
