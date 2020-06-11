import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/entities/entities.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repository/search_locations_repository.dart';
import '../data_sources/search_locations_local_data_source.dart';
import '../data_sources/search_locations_remote_data_source.dart';

class SearchLocationsRepositoryImpl implements SearchLocationsRepository {
  final SearchLocationsRemoteDataSource dataSource;
  final SearchLocationsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  SearchLocationsRepositoryImpl({
    @required this.dataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

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
      return Right(await localDataSource.getRecentlySearchedLocationsList());
    } on NoLocalDataException {
      return Left(NoLocalDataFailure());
    }
  }

  @override
  Future<Either<Failure, LocationsList>>
      clearAllRecentlySearchedLocation() async {
    try {
      await localDataSource.clearAllRecentlySearchedLocation();
      return Right(LocationsList(locationsList: []));
    } on NoLocalDataException {
      return Left(NoLocalDataFailure());
    } on UnexpectedException {
      return Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, LocationsList>> clearOneRecentlySearchedLocation(
      String id) async {
    try {
      return Right(await localDataSource.clearOneRecentlySearchedLocation(id));
    } on NoLocalDataException {
      return Left(NoLocalDataFailure());
    } on UnexpectedException {
      return Left(UnexpectedFailure());
    }
  }
}
