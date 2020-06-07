import 'package:dartz/dartz.dart';
import 'package:weader/features/locations/domain/repository/locations_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class ClearAllRecentlySearchedLocationsList extends UseCase<bool, NoParams> {
  final LocationsRepository repository;

  ClearAllRecentlySearchedLocationsList(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.clearAllRecentlySearchedLocation();
  }
}
