import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Location extends Equatable {
  final String displayName;
  final String address;
  final double latitude;
  final double longitude;

  Location({
    @required this.displayName,
    @required this.address,
    @required this.latitude,
    @required this.longitude,
  });

  @override
  List<Object> get props => [
        displayName,
        address,
        latitude,
        longitude,
      ];
}
