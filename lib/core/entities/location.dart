import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Location extends Equatable {
  final String displayName;
  final String address;
  final double latitude;
  final double longitude;
  final String id;

  Location({
    @required this.displayName,
    @required this.address,
    @required this.latitude,
    @required this.longitude,
    @required this.id,
  });

  @override
  List<Object> get props => [
        displayName,
        address,
        latitude,
        longitude,
        id,
      ];
}
