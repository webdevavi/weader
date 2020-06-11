import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/entities/entities.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/save_locations_repository.dart';

class SaveLocation extends UseCase<LocationsList, SaveLocationParams> {
  final SaveLocationsRepository repository;

  SaveLocation(this.repository);

  @override
  Future<Either<Failure, LocationsList>> call(SaveLocationParams params) async {
    return await repository.saveLocation(params.location);
  }
}

class SaveLocationParams extends Equatable {
  final Location location;

  SaveLocationParams({@required this.location});
  @override
  List<Object> get props => [location];
}
