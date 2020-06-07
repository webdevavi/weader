import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weader/core/error/exception.dart';
import 'package:weader/core/error/failures.dart';
import 'package:weader/core/network/network_info.dart';
import 'package:weader/features/locations/data/data_sources/locations_data_source.dart';
import 'package:weader/features/locations/data/data_sources/locations_local_data_source.dart';
import 'package:weader/features/locations/data/models/location_model.dart';
import 'package:weader/features/locations/data/models/locations_list_model.dart';
import 'package:weader/features/locations/data/repository/locations_repository_impl.dart';
import 'package:weader/features/locations/domain/entities/locations_list.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockLocationsDataSource extends Mock implements LocationsDataSource {}

class MockLocationsLocalDataSource extends Mock
    implements LocationsLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  LocationsRepositoryImpl repository;
  MockLocationsDataSource mockLocationsDataSource;
  LocationsLocalDataSource mockLocationsLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockLocationsDataSource = MockLocationsDataSource();
    mockLocationsLocalDataSource = MockLocationsLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = LocationsRepositoryImpl(
      dataSource: mockLocationsDataSource,
      localDataSource: mockLocationsLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final tRecentlySearchedLocationsList = Future.value(
    LocationsListModel.fromJson(
      json.decode(
        fixture('recently_searched_locations_list.json'),
      ),
    ),
  );

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

    test(
      'should check if device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        // act
        repository.getLocationsList(tQueryString);
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    test(
      'should return a network failure when the device is offline',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        // act
        final result = await repository.getLocationsList(tQueryString);
        // assert
        expect(result, Left(NetworkFailure()));
      },
    );

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        '''should call local data source to get recently searched locations list
        and then should call setRecentlySearchedLocationsList if the result of 
        getRecentlySearchedLocationsList is not null after adding the new locationsList to previous list''',
        () async {
          when(mockLocationsDataSource.getLocationsList(tQueryString))
              .thenAnswer((_) async => tLocationsListModel);
          when(mockLocationsLocalDataSource.getRecentlySearchedLocationsList())
              .thenAnswer((_) async => tRecentlySearchedLocationsList);
          // act
          await repository.getLocationsList(tQueryString);
          // assert

          verify(
            mockLocationsLocalDataSource.setRecentlySearchedLocationsList(
              tNewLocationsListModel,
            ),
          );
        },
      );

      test(
        '''should call local data source to get recently searched locations list
        and then should call setRecentlySearchedLocationsList for the current locationsList if the result of 
        getRecentlySearchedLocationsList is null''',
        () async {
          when(mockLocationsDataSource.getLocationsList(tQueryString))
              .thenAnswer((_) async => tLocationsListModel);
          when(mockLocationsLocalDataSource.getRecentlySearchedLocationsList())
              .thenThrow(NoLocalDataException());
          // act
          await repository.getLocationsList(tQueryString);
          // assert

          verify(
            mockLocationsLocalDataSource.setRecentlySearchedLocationsList(
              tLocationsListModel,
            ),
          );
        },
      );

      test(
        'should return data when the call to data source is successful',
        () async {
          // arrange
          when(mockLocationsDataSource.getLocationsList(tQueryString))
              .thenAnswer((_) async => tLocationsListModel);
          when(mockLocationsLocalDataSource.getRecentlySearchedLocationsList())
              .thenAnswer((_) async => tRecentlySearchedLocationsList);
          // act
          final result = await repository.getLocationsList(tQueryString);
          // assert
          verify(mockLocationsDataSource.getLocationsList(tQueryString));
          expect(result, equals(Right(tLocationsList)));
        },
      );

      test(
        'should return Not Found failure when the data is not present',
        () async {
          // arrange
          when(mockLocationsDataSource.getLocationsList(tQueryString))
              .thenThrow(NotFoundException());
          // act
          final result = await repository.getLocationsList(tQueryString);
          // assert
          verify(mockLocationsDataSource.getLocationsList(tQueryString));
          expect(result, equals(Left(NotFoundFailure())));
        },
      );
    });
  });

  group('getDeviceLocationsList', () {
    final tLocationsListModel = LocationsListModel(
      locationsList: [
        LocationModel(
          id: "cdef4a60-a821-11ea-fbdc-4fc75fc69aa5",
          address: 'Karnataka, India',
          displayName: 'Bengaluru',
          latitude: 1.0,
          longitude: 1.0,
        ),
      ],
    );
    final LocationsList tLocationsList = tLocationsListModel;

    test(
      'should return data when the call to device location package is successful',
      () async {
        // arrange
        when(mockLocationsDataSource.getDeviceLocationsList())
            .thenAnswer((_) async => tLocationsListModel);
        // act
        final result = await repository.getDeviceLocationsList();
        // assert
        verify(mockLocationsDataSource.getDeviceLocationsList());
        expect(result, equals(Right(tLocationsList)));
      },
    );

    test(
      'should return device location failure when the call to device location package is unsuccessful',
      () async {
        // arrange
        when(mockLocationsDataSource.getDeviceLocationsList())
            .thenThrow(DeviceLocationException());
        // act
        final result = await repository.getDeviceLocationsList();
        // assert
        verify(mockLocationsDataSource.getDeviceLocationsList());
        expect(result, equals(Left(DeviceLocationFailure())));
      },
    );

    test(
      'should return Not Found failure when the data is not present',
      () async {
        // arrange
        when(mockLocationsDataSource.getDeviceLocationsList())
            .thenThrow(NotFoundException());
        // act
        final result = await repository.getDeviceLocationsList();
        // assert
        verify(mockLocationsDataSource.getDeviceLocationsList());
        expect(result, equals(Left(NotFoundFailure())));
      },
    );
  });

  group('getRecentlySearchedLocationsList', () {
    test(
      'should return local data when the call to shared preferences is successful',
      () async {
        // arrange
        when(mockLocationsLocalDataSource.getRecentlySearchedLocationsList())
            .thenAnswer((_) async => Future.value(tLocationsListModel));
        // act
        final result = await repository.getRecentlySearchedLocationsList();
        // assert
        verify(mockLocationsLocalDataSource.getRecentlySearchedLocationsList());
        expect(result, equals(Right(tLocationsList)));
      },
    );

    test(
      'should return NoLocalDataException when the data is not present',
      () async {
        // arrange
        when(mockLocationsLocalDataSource.getRecentlySearchedLocationsList())
            .thenThrow(NoLocalDataException());
        // act
        final result = await repository.getRecentlySearchedLocationsList();
        // assert
        verify(mockLocationsLocalDataSource.getRecentlySearchedLocationsList());
        expect(result, equals(Left(NoLocalDataFailure())));
      },
    );
  });

  group('clearOneRecentlySearchedLocation', () {
    final tId = "cdef4a60-a821-11ea-fbdc-4fc75fc69aa5";

    test(
      'should return new locations list model having one model removed',
      () async {
        // arrange
        when(mockLocationsLocalDataSource.clearOneRecentlySearchedLocation(any))
            .thenAnswer((_) async => Future.value(tLocationsListModel));
        // act
        final result = await repository.clearOneRecentlySearchedLocation(tId);
        // assert
        verify(
            mockLocationsLocalDataSource.clearOneRecentlySearchedLocation(tId));
        expect(result, equals(Right(tLocationsListModel)));
      },
    );

    test(
      'should return NoLocalDataException when the data is not present',
      () async {
        // arrange
        when(mockLocationsLocalDataSource.clearOneRecentlySearchedLocation(any))
            .thenThrow(NoLocalDataException());
        // act
        final result = await repository.clearOneRecentlySearchedLocation(tId);
        // assert
        verify(
            mockLocationsLocalDataSource.clearOneRecentlySearchedLocation(tId));
        expect(result, equals(Left(NoLocalDataFailure())));
      },
    );
  });

  group('clearAllRecentlySearchedLocation', () {
    test(
      'should return true',
      () async {
        // arrange
        when(mockLocationsLocalDataSource.clearAllRecentlySearchedLocation())
            .thenAnswer((_) async => Future.value(true));
        // act
        final result = await repository.clearAllRecentlySearchedLocation();
        // assert
        verify(mockLocationsLocalDataSource.clearAllRecentlySearchedLocation());
        expect(result, equals(Right(true)));
      },
    );

    test(
      'should return UnexpectedException when the data is not present',
      () async {
        // arrange
        when(mockLocationsLocalDataSource.clearAllRecentlySearchedLocation())
            .thenThrow(UnexpectedException());
        // act
        final result = await repository.clearAllRecentlySearchedLocation();
        // assert
        verify(mockLocationsLocalDataSource.clearAllRecentlySearchedLocation());
        expect(result, equals(Left(UnexpectedFailure())));
      },
    );
  });
}
