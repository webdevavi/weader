import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:Weader/core/entities/entities.dart';
import 'package:Weader/core/entities/location.dart';
import 'package:Weader/core/error/exception.dart';
import 'package:Weader/core/error/failures.dart';
import 'package:Weader/core/models/models.dart';
import 'package:Weader/features/save_locations/data/data_sources/save_locations_local_data_source.dart';
import 'package:Weader/features/save_locations/data/repository/save_locations_repository_impl.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSaveLocationsLocalDataSource extends Mock
    implements SaveLocationsLocalDataSource {}

void main() {
  SaveLocationsRepositoryImpl repository;
  SaveLocationsLocalDataSource mockSaveLocationsLocalDataSource;

  setUp(() {
    mockSaveLocationsLocalDataSource = MockSaveLocationsLocalDataSource();

    repository = SaveLocationsRepositoryImpl(
      localDataSource: mockSaveLocationsLocalDataSource,
    );
  });

  final tLocationsListModel = LocationsListModel(
    locationsList: [
      LocationModel(
        id: "cdef4a60-a821-11ea-fbdc-4fc75fc69aa5",
        address: 'Bengaluru, Bengaluru Urban, Karnataka, India',
        displayName: 'Bengaluru',
        latitude: 12.9715987,
        longitude: 77.5945627,
      ),
    ],
  );

  final LocationsList tLocationsList = tLocationsListModel;

  group('getLocationsList', () {
    final tQueryString = 'bengaluru';

    final tNewLocationsListModel = LocationsListModel(locationsList: [
      LocationModel(
        id: "cdef4a60-a821-11ea-fbdc-4fc75fc69aa5",
        address: 'Bengaluru, Bengaluru Urban, Karnataka, India',
        displayName: 'Bengaluru',
        latitude: 12.9715987,
        longitude: 77.5945627,
      ),
      LocationModel(
        id: "cdef4a60-a821-11ea-fbdc-4fc75fc69aa5",
        address: 'Bengaluru, Bengaluru Urban, Karnataka, India',
        displayName: 'Bengaluru',
        latitude: 12.9715987,
        longitude: 77.5945627,
      ),
    ]);

    group('getSavedLocationsList', () {
      test(
        'should return locations list',
        () async {
          // arrange
          when(mockSaveLocationsLocalDataSource.getSavedLocationsList())
              .thenAnswer((_) async => Future.value(tLocationsListModel));
          // act
          final result = await repository.getSavedLocationsList();
          // assert
          verify(mockSaveLocationsLocalDataSource.getSavedLocationsList());
          expect(result, equals(Right(tLocationsList)));
        },
      );

      test(
        'should return NoLocalDataFailure when the data is not present',
        () async {
          // arrange
          when(mockSaveLocationsLocalDataSource.getSavedLocationsList())
              .thenThrow(NoLocalDataException());
          // act
          final result = await repository.getSavedLocationsList();
          // assert
          expect(result, equals(Left(NoLocalDataFailure())));
        },
      );
    });

    group('saveLocation', () {
      final tLocationModel = LocationModel(
        id: "cdef4a60-a821-11ea-fbdc-4fc75fc69aa5",
        address: 'Bengaluru, Bengaluru Urban, Karnataka, India',
        displayName: 'Bengaluru',
        latitude: 12.9715987,
        longitude: 77.5945627,
      );
      final Location tLocation = tLocationModel;
      final tLocationsListModelForFailure = LocationsListModel(
        locationsList: [tLocation],
      );

      final tLocationsListModelForSuccess = LocationsListModel(
        locationsList: [
          LocationModel(
            id: "cdef4a60-a821-11ea-fbdc-4fc75fc69aa5",
            address: 'Bengaluru, Bengaluru Urban, Karnataka, India',
            displayName: 'Bengaluru',
            latitude: 12.60,
            longitude: 77.50,
          )
        ],
      );

      final tNewLocationsListModel = LocationsListModel(
        locationsList: [
          LocationModel(
            id: "cdef4a60-a821-11ea-fbdc-4fc75fc69aa5",
            address: 'Bengaluru, Bengaluru Urban, Karnataka, India',
            displayName: 'Bengaluru',
            latitude: 12.60,
            longitude: 77.50,
          ),
          tLocationModel,
        ],
      );

      test(
        'should call getSavedLocationsList to get the previously saved locationslist if there is any',
        () async {
          // arrange
          when(mockSaveLocationsLocalDataSource.getSavedLocationsList())
              .thenAnswer(
            (_) async => Future.value(
              tLocationsListModel,
            ),
          );
          // act
          repository.saveLocation(tLocation);
          // assert
          verify(mockSaveLocationsLocalDataSource.getSavedLocationsList());
        },
      );

      test(
        'should return LocationAlreadySavedFailure when the location passed is already present in the previously saved list',
        () async {
          // arrange
          when(mockSaveLocationsLocalDataSource.getSavedLocationsList())
              .thenAnswer(
            (_) async => Future.value(
              tLocationsListModelForFailure,
            ),
          );
          // act
          final result = await repository.saveLocation(tLocation);
          // assert
          expect(result, equals(Left(LocationAlreadySavedFailure())));
        },
      );

      test(
        '''should call saveLocation to save the locationModel if locations is not already saved
      and return the new saved locations list''',
        () async {
          // arrange
          when(mockSaveLocationsLocalDataSource.getSavedLocationsList())
              .thenAnswer(
            (_) async => Future.value(
              tLocationsListModelForSuccess,
            ),
          );
          // act
          final result = await repository.saveLocation(tLocation);
          // assert
          verify(mockSaveLocationsLocalDataSource
              .saveLocation(tNewLocationsListModel));
          expect(result, equals(Right(tNewLocationsListModel)));
        },
      );

      test(
        'should save the location in a new list when the data is not present',
        () async {
          // arrange
          when(mockSaveLocationsLocalDataSource.getSavedLocationsList())
              .thenThrow(NoLocalDataException());
          // act
          final result = await repository.saveLocation(tLocation);
          // assert
          expect(
            result,
            equals(Right(LocationsList(locationsList: [tLocationModel]))),
          );
        },
      );

      test(
        'should return unexpected failure when saving fails',
        () async {
          // arrange
          when(mockSaveLocationsLocalDataSource.getSavedLocationsList())
              .thenAnswer(
            (_) async => Future.value(
              LocationsListModel(locationsList: []),
            ),
          );
          when(mockSaveLocationsLocalDataSource
                  .saveLocation(tLocationsListModel))
              .thenThrow(UnexpectedException());
          // act
          final result = await repository.saveLocation(tLocation);
          // assert
          expect(
            result,
            equals(Left(UnexpectedFailure())),
          );
        },
      );
    });

    group('deleteSavedLocation', () {
      final tId = "cdef4a60-a821-11ea-fbdc-4fc75fc69aa5";

      test(
        'should return locations list',
        () async {
          // arrange
          when(mockSaveLocationsLocalDataSource.deleteSavedLocation(any))
              .thenAnswer((_) async => Future.value(tLocationsListModel));
          // act
          final result = await repository.deleteSavedLocation(tId);
          // assert
          verify(mockSaveLocationsLocalDataSource.deleteSavedLocation(tId));
          expect(result, equals(Right(tLocationsList)));
        },
      );

      test(
        'should return NoLocalDataFailure when the data is not present',
        () async {
          // arrange
          when(mockSaveLocationsLocalDataSource.deleteSavedLocation(any))
              .thenThrow(NoLocalDataException());
          // act
          final result = await repository.deleteSavedLocation(tId);
          // assert
          expect(result, equals(Left(NoLocalDataFailure())));
        },
      );

      test(
        'should return unexpected failure when saving fails',
        () async {
          // arrange
          when(mockSaveLocationsLocalDataSource.deleteSavedLocation(any))
              .thenThrow(UnexpectedException());
          // act
          final result = await repository.deleteSavedLocation(tId);
          // assert
          expect(result, equals(Left(UnexpectedFailure())));
        },
      );
    });

    group('deleteAllSavedLocations', () {
      test(
        'should return UnexpectedException when deleting fails',
        () async {
          // arrange
          when(mockSaveLocationsLocalDataSource.deleteAllSavedLocations())
              .thenThrow(UnexpectedException());
          // act
          final result = await repository.deleteAllSavedLocations();
          // assert
          expect(result, equals(Left(UnexpectedFailure())));
        },
      );
    });
  });
}
