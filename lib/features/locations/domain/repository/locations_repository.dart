import 'package:dartz/dartz.dart';
import 'package:weader/core/error/failures.dart';
import 'package:weader/features/locations/domain/entities/locations_list.dart';

abstract class LocationsRepository {
  Future<Either<Failure, LocationsList>> getLocationsList(String queryString);
  Future<Either<Failure, LocationsList>> getDeviceLocationsList();
}
