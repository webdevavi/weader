import 'package:dartz/dartz.dart';

import '../../../../core/entities/entities.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/search_locations_repository.dart';

class ClearAllRecentlySearchedLocationsList
    extends UseCase<LocationsList, NoParams> {
  final SearchLocationsRepository repository;

  ClearAllRecentlySearchedLocationsList(this.repository);

  @override
  Future<Either<Failure, LocationsList>> call(NoParams params) async {
    return await repository.clearAllRecentlySearchedLocation();
  }
}
