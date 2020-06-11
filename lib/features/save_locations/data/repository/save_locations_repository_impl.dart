import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/entities/entities.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/models/models.dart';
import '../../domain/repository/save_locations_repository.dart';
import '../data_sources/save_locations_local_data_source.dart';

class SaveLocationsRepositoryImpl implements SaveLocationsRepository {
  final SaveLocationsLocalDataSource localDataSource;

  SaveLocationsRepositoryImpl({
    @required this.localDataSource,
  });

  @override
  Future<Either<Failure, LocationsList>> saveLocation(Location location) async {
    final LocationModel locationModel = LocationModel(
      address: location.address,
      displayName: location.displayName,
      latitude: location.latitude,
      longitude: location.longitude,
      id: location.id,
    );
    try {
      final savedLocationsList = await localDataSource.getSavedLocationsList();

      final isAlreadySaved = _checkIfAlreadySaved(
        savedLocationsList,
        location,
      );

      if (isAlreadySaved) return Left(LocationAlreadySavedFailure());

      savedLocationsList.locationsList.add(locationModel);
      try {
        await localDataSource.saveLocation(savedLocationsList);
      } on UnexpectedException {
        return Left(UnexpectedFailure());
      }
      return Right(savedLocationsList);
    } on NoLocalDataException {
      try {
        await localDataSource
            .saveLocation(LocationsListModel(locationsList: [locationModel]));
      } on UnexpectedException {
        return Left(UnexpectedFailure());
      }
      return Right(LocationsList(locationsList: [locationModel]));
    }
  }

  @override
  Future<Either<Failure, LocationsList>> deleteSavedLocation(String id) async {
    try {
      return Right(await localDataSource.deleteSavedLocation(id));
    } on NoLocalDataException {
      return Left(NoLocalDataFailure());
    } on UnexpectedException {
      return Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, LocationsList>> getSavedLocationsList() async {
    try {
      return Right(await localDataSource.getSavedLocationsList());
    } on NoLocalDataException {
      return Left(NoLocalDataFailure());
    }
  }

  @override
  Future<Either<Failure, LocationsList>> deleteAllSavedLocations() async {
    try {
      await localDataSource.deleteAllSavedLocations();
      return Right(LocationsList(locationsList: []));
    } on NoLocalDataException {
      return Left(NoLocalDataFailure());
    } on UnexpectedException {
      return Left(UnexpectedFailure());
    }
  }

  bool _checkIfAlreadySaved(
    LocationsListModel locationsList,
    Location location,
  ) {
    if ((locationsList.locationsList.singleWhere(
            (savedLocation) =>
                savedLocation.latitude == location.latitude &&
                savedLocation.longitude == location.longitude,
            orElse: () => null)) !=
        null) {
      return true;
    } else
      return false;
  }
}
