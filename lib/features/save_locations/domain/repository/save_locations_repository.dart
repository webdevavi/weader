import 'package:dartz/dartz.dart';

import '../../../../core/entities/entities.dart';
import '../../../../core/error/failures.dart';

abstract class SaveLocationsRepository {
  Future<Either<Failure, LocationsList>> saveLocation(Location location);
  Future<Either<Failure, LocationsList>> getSavedLocationsList();
  Future<Either<Failure, LocationsList>> deleteSavedLocation(String id);
  Future<Either<Failure, LocationsList>> deleteAllSavedLocations();
}
