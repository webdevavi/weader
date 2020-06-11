import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'entities.dart';

class LocationsList extends Equatable {
  final List<Location> locationsList;

  LocationsList({@required this.locationsList});
  @override
  List<Object> get props => [locationsList];
}
