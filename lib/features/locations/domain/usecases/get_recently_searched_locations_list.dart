import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/locations_list.dart';
import '../repository/locations_repository.dart';

class GetRecentlySearchedLocationsList
    extends UseCase<LocationsList, NoParams> {
  final LocationsRepository repository;

  GetRecentlySearchedLocationsList(this.repository);

  @override
  Future<Either<Failure, LocationsList>> call(NoParams params) async {
    return await repository.getRecentlySearchedLocationsList();
  }
}
