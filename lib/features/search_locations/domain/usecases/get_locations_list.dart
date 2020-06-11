import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/entities/entities.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/search_locations_repository.dart';

class GetLocationsList extends UseCase<LocationsList, Params> {
  final SearchLocationsRepository repository;

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
