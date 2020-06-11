import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SearchLocationsEvent extends Equatable {
  SearchLocationsEvent();
}

class GetLocationsListEvent extends SearchLocationsEvent {
  final String queryString;

  GetLocationsListEvent(this.queryString);
  @override
  List<Object> get props => [queryString];
}

class GetDeviceLocationsListEvent extends SearchLocationsEvent {
  @override
  List<Object> get props => [];
}

class GetRecentlySearchedLocationsListEvent extends SearchLocationsEvent {
  @override
  List<Object> get props => [];
}

class ClearOneRecentlySearchedLocationEvent extends SearchLocationsEvent {
  final String id;

  ClearOneRecentlySearchedLocationEvent({@required this.id});
  @override
  List<Object> get props => [id];
}

class ClearAllRecentlySearchedLocationsListEvent extends SearchLocationsEvent {
  @override
  List<Object> get props => [];
}
