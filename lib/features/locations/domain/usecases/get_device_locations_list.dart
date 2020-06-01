import 'package:weader/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:weader/core/usecases/usecase.dart';
import 'package:weader/features/locations/domain/entities/locations_list.dart';
import 'package:weader/features/locations/domain/repository/locations_repository.dart';

class GetDeviceLocationsList extends UseCase<LocationsList, NoParams> {
  final LocationsRepository repository;

  GetDeviceLocationsList(this.repository);
  @override
  Future<Either<Failure, LocationsList>> call(NoParams params) async {
    return await repository.getDeviceLocationsList();
  }
}
