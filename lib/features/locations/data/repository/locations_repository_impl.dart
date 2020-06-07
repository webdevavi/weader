import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:weader/core/network/network_info.dart';
import 'package:weader/features/locations/data/data_sources/locations_local_data_source.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/locations_list.dart';
import '../../domain/repository/locations_repository.dart';
import '../data_sources/locations_data_source.dart';

class LocationsRepositoryImpl implements LocationsRepository {
  final LocationsDataSource dataSource;
  final LocationsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  LocationsRepositoryImpl({
    @required this.dataSource,
    @required this.localDataSource,
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
        final locationsList = await dataSource.getLocationsList(queryString);

        try {
          final recentlySearchedLocationsList =
              await localDataSource.getRecentlySearchedLocationsList();

          locationsList.locationsList.forEach((location) {
            recentlySearchedLocationsList.locationsList.add(location);
          });

          await localDataSource
              .setRecentlySearchedLocationsList(recentlySearchedLocationsList);
        } on NoLocalDataException {
          await localDataSource.setRecentlySearchedLocationsList(locationsList);
        }

        return Right(locationsList);
      } on NotFoundException {
        return Left(NotFoundFailure());
      }
    else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, LocationsList>>
      getRecentlySearchedLocationsList() async {
    try {
      final recentlySearchedLocationsList =
          await localDataSource.getRecentlySearchedLocationsList();

      return Right(recentlySearchedLocationsList);
    } on NoLocalDataException {
      return Left(NoLocalDataFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> clearAllRecentlySearchedLocation() async {
    try {
      return Right(await localDataSource.clearAllRecentlySearchedLocation());
    } on UnexpectedException {
      return Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, LocationsList>> clearOneRecentlySearchedLocation(
      String id) async {
    try {
      return Right(await localDataSource.clearOneRecentlySearchedLocation(id));
    } on Exception {
      return Left(NoLocalDataFailure());
    }
  }
}
