import 'package:dartz/dartz.dart';

import '../../../../core/entities/entities.dart';
import '../../../../core/error/failures.dart';

abstract class SearchLocationsRepository {
  Future<Either<Failure, LocationsList>> getLocationsList(String queryString);
  Future<Either<Failure, LocationsList>> getRecentlySearchedLocationsList();
  Future<Either<Failure, LocationsList>> clearOneRecentlySearchedLocation(
    String id,
  );
  Future<Either<Failure, LocationsList>> clearAllRecentlySearchedLocation();
}
