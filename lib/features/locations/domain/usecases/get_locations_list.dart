import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:weader/core/usecases/usecase.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../entities/locations_list.dart';
import '../repository/locations_repository.dart';

class GetLocationsList extends UseCase<LocationsList, Params> {
  final LocationsRepository repository;

  GetLocationsList(this.repository);

  @override
  Future<Either<Failure, LocationsList>> call(Params params) async {
    return await repository.getLocationsList(params.queryString);
  }
}

class Params extends Equatable {
  final String queryString;

  Params({
    @required this.queryString,
  });
  @override
  List<Object> get props => [queryString];
}
