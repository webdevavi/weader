import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:weader/core/network/network_info.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/locations_list.dart';
import '../../domain/repository/locations_repository.dart';
import '../data_sources/locations_data_source.dart';

class LocationsRepositoryImpl implements LocationsRepository {
  final LocationsDataSource dataSource;
  final NetworkInfo networkInfo;

  LocationsRepositoryImpl({
    @required this.dataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, LocationsList>> getDeviceLocationsList() async {
    try {
      return Right(await dataSource.getDeviceLocationsList());
    } on DeviceLocationException {
      return Left(DeviceLocationFailure());
    } on NotFoundException {
      return Left(NotFoundFailure());
    }
  }

  @override
  Future<Either<Failure, LocationsList>> getLocationsList(
      String queryString) async {
    if (await networkInfo.isConnected)
      try {
        return Right(await dataSource.getLocationsList(queryString));
      } on NotFoundException {
        return Left(NotFoundFailure());
      }
    else
      return Left(NetworkFailure());
  }
}
