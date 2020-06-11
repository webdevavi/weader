import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/entities/entities.dart';

@immutable
abstract class SearchLocationsState extends Equatable {
  SearchLocationsState();
}

class SearchLocationsEmpty extends SearchLocationsState {
  @override
  List<Object> get props => [];
}

class SearchLocationsLoading extends SearchLocationsState {
  @override
  List<Object> get props => [];
}

class SearchLocationsLoaded extends SearchLocationsState {
  final LocationsList locationsList;

  SearchLocationsLoaded({@required this.locationsList});
  @override
  List<Object> get props => [locationsList];
}

class RecentlySearchedLocationsLoaded extends SearchLocationsState {
  final LocationsList recentlySearchedLocationsList;

  RecentlySearchedLocationsLoaded(
      {@required this.recentlySearchedLocationsList});
  @override
  List<Object> get props => [recentlySearchedLocationsList];
}

class SearchLocationsError extends SearchLocationsState {
  final String message;

  SearchLocationsError({@required this.message});
  @override
  List<Object> get props => [message];
}
