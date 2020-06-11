import 'package:dartz/dartz.dart';

import '../../../../core/entities/entities.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/save_locations_repository.dart';

class DeleteAllSavedLocations extends UseCase<LocationsList, NoParams> {
  final SaveLocationsRepository repository;

  DeleteAllSavedLocations(this.repository);

  @override
  Future<Either<Failure, LocationsList>> call(NoParams params) async {
    return await repository.deleteAllSavedLocations();
  }
}
