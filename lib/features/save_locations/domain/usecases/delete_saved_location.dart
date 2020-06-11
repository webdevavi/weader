import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/entities/entities.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/save_locations_repository.dart';

class DeleteSavedLocation
    extends UseCase<LocationsList, DeleteSavedLocationParams> {
  final SaveLocationsRepository repository;

  DeleteSavedLocation(this.repository);

  @override
  Future<Either<Failure, LocationsList>> call(
      DeleteSavedLocationParams params) async {
    return await repository.deleteSavedLocation(params.id);
  }
}

class DeleteSavedLocationParams extends Equatable {
  final String id;

  DeleteSavedLocationParams({@required this.id});
  @override
  List<Object> get props => [id];
}
