import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/entities/entities.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/search_locations_repository.dart';

class ClearOneRecentlySearchedLocation
    extends UseCase<LocationsList, IDParams> {
  final SearchLocationsRepository repository;

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
