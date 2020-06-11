import 'package:dartz/dartz.dart';

import '../../../../core/entities/entities.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/search_locations_repository.dart';

class GetRecentlySearchedLocationsList
    extends UseCase<LocationsList, NoParams> {
  final SearchLocationsRepository repository;

  GetRecentlySearchedLocationsList(this.repository);

  @override
  Future<Either<Failure, LocationsList>> call(NoParams params) async {
    return await repository.getRecentlySearchedLocationsList();
  }
}
