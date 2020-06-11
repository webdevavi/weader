import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class LocationPosition extends Equatable {
  final double latitude;
  final double longitude;

  LocationPosition({
    @required this.latitude,
    @required this.longitude,
  });
  @override
  List<Object> get props => [latitude, longitude];
}
