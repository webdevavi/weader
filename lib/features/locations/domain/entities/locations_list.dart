import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:weader/core/entities/entities.dart';

class LocationsList extends Equatable {
  final List<Location> locationsList;

  LocationsList({@required this.locationsList});
  @override
  List<Object> get props => [locationsList];
}
