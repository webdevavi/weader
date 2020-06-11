import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:Weader/core/entities/entities.dart';
import 'package:Weader/core/error/exception.dart';
import 'package:Weader/core/error/failures.dart';
import 'package:Weader/core/models/models.dart';
import 'package:Weader/core/network/network_info.dart';
import 'package:Weader/features/search_locations/data/data_sources/search_locations_local_data_source.dart';
import 'package:Weader/features/search_locations/data/data_sources/search_locations_remote_data_source.dart';
import 'package:Weader/features/search_locations/data/repository/search_locations_repository_impl.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSearchLocationsRemoteDataSource extends Mock
    implements SearchLocationsRemoteDataSource {}

class MockSearchLocationsLocalDataSource extends Mock
    implements SearchLocationsLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  SearchLocationsRepositoryImpl repository;
  MockSearchLocationsRemoteDataSource mockSearchLocationsRemoteDataSource;
  MockSearchLocationsLocalDataSource mockSearchLocationsLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockSearchLocationsRemoteDataSource = MockSearchLocationsRemoteDataSource();
    mockSearchLocationsLocalDataSource = MockSearchLocationsLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = SearchLocationsRepositoryImpl(
      dataSource: mockSearchLocationsRemoteDataSource,
      localDataSource: mockSearchLocationsLocalDataSource,
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
          when(mockSearchLocationsRemoteDataSource
                  .getLocationsList(tQueryString))
              .thenAnswer((_) async => tLocationsListModel);
          when(mockSearchLocationsLocalDataSource
                  .getRecentlySearchedLocationsList())
              .thenAnswer((_) async => tRecentlySearchedLocationsList);
          // act
          await repository.getLocationsList(tQueryString);
          // assert

          verify(
            mockSearchLocationsLocalDataSource.setRecentlySearchedLocationsList(
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
          when(mockSearchLocationsRemoteDataSource
                  .getLocationsList(tQueryString))
              .thenAnswer((_) async => tLocationsListModel);
          when(mockSearchLocationsLocalDataSource
                  .getRecentlySearchedLocationsList())
              .thenThrow(NoLocalDataException());
          // act
          await repository.getLocationsList(tQueryString);
          // assert

          verify(
            mockSearchLocationsLocalDataSource.setRecentlySearchedLocationsList(
              tLocationsListModel,
            ),
          );
        },
      );

      test(
        'should return data when the call to data source is successful',
        () async {
          // arrange
          when(mockSearchLocationsRemoteDataSource
                  .getLocationsList(tQueryString))
              .thenAnswer((_) async => tLocationsListModel);
          when(mockSearchLocationsLocalDataSource
                  .getRecentlySearchedLocationsList())
              .thenAnswer((_) async => tRecentlySearchedLocationsList);
          // act
          final result = await repository.getLocationsList(tQueryString);
          // assert
          verify(mockSearchLocationsRemoteDataSource
              .getLocationsList(tQueryString));
          expect(result, equals(Right(tLocationsList)));
        },
      );

      test(
        'should return Not Found failure when the data is not present',
        () async {
          // arrange
          when(mockSearchLocationsRemoteDataSource
                  .getLocationsList(tQueryString))
              .thenThrow(NotFoundException());
          // act
          final result = await repository.getLocationsList(tQueryString);
          // assert
          verify(mockSearchLocationsRemoteDataSource
              .getLocationsList(tQueryString));
          expect(result, equals(Left(NotFoundFailure())));
        },
      );
    });
  });

  group('getRecentlySearchedLocationsList', () {
    test(
      'should return local data when the call to shared preferences is successful',
      () async {
        // arrange
        when(mockSearchLocationsLocalDataSource
                .getRecentlySearchedLocationsList())
            .thenAnswer((_) async => Future.value(tLocationsListModel));
        // act
        final result = await repository.getRecentlySearchedLocationsList();
        // assert
        verify(mockSearchLocationsLocalDataSource
            .getRecentlySearchedLocationsList());
        expect(result, equals(Right(tLocationsList)));
      },
    );

    test(
      'should return NoLocalDataException when the data is not present',
      () async {
        // arrange
        when(mockSearchLocationsLocalDataSource
                .getRecentlySearchedLocationsList())
            .thenThrow(NoLocalDataException());
        // act
        final result = await repository.getRecentlySearchedLocationsList();
        // assert
        verify(mockSearchLocationsLocalDataSource
            .getRecentlySearchedLocationsList());
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
        when(mockSearchLocationsLocalDataSource
                .clearOneRecentlySearchedLocation(any))
            .thenAnswer((_) async => Future.value(tLocationsListModel));
        // act
        final result = await repository.clearOneRecentlySearchedLocation(tId);
        // assert
        verify(mockSearchLocationsLocalDataSource
            .clearOneRecentlySearchedLocation(tId));
        expect(result, equals(Right(tLocationsListModel)));
      },
    );

    test(
      'should return NoLocalDataException when the data is not present',
      () async {
        // arrange
        when(mockSearchLocationsLocalDataSource
                .clearOneRecentlySearchedLocation(any))
            .thenThrow(NoLocalDataException());
        // act
        final result = await repository.clearOneRecentlySearchedLocation(tId);
        // assert
        verify(mockSearchLocationsLocalDataSource
            .clearOneRecentlySearchedLocation(tId));
        expect(result, equals(Left(NoLocalDataFailure())));
      },
    );

    test(
      'should return unexpected failure when deleting fails',
      () async {
        // arrange
        when(mockSearchLocationsLocalDataSource
                .clearOneRecentlySearchedLocation(any))
            .thenThrow(UnexpectedException());
        // act
        final result = await repository.clearOneRecentlySearchedLocation(tId);
        // assert
        verify(mockSearchLocationsLocalDataSource
            .clearOneRecentlySearchedLocation(tId));
        expect(result, equals(Left(UnexpectedFailure())));
      },
    );
  });

  group('clearAllRecentlySearchedLocation', () {
    test(
      'should return UnexpectedException when the data is not cleared',
      () async {
        // arrange
        when(mockSearchLocationsLocalDataSource
                .clearAllRecentlySearchedLocation())
            .thenThrow(UnexpectedException());
        // act
        final result = await repository.clearAllRecentlySearchedLocation();
        // assert
        verify(mockSearchLocationsLocalDataSource
            .clearAllRecentlySearchedLocation());
        expect(result, equals(Left(UnexpectedFailure())));
      },
    );
  });
}
