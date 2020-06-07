import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:weader/features/locations/domain/repository/locations_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/locations_list.dart';

class ClearOneRecentlySearchedLocation
    extends UseCase<LocationsList, IDParams> {
  final LocationsRepository repository;

  ClearOneRecentlySearchedLocation(this.repository);

  @override
  Future<Either<Failure, LocationsList>> call(IDParams params) async {
    return await repository.clearOneRecentlySearchedLocation(params.id);
  }
}

class IDParams extends Equatable {
  final String id;

  IDParams({@required this.id});

  @override
  List<Object> get props => [id];
}
