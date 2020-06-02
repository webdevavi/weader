import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weader/core/error/exception.dart';
import 'package:weader/core/error/failures.dart';
import 'package:weader/features/locations/data/data_sources/locations_data_source.dart';
import 'package:weader/features/locations/data/models/location_model.dart';
import 'package:weader/features/locations/data/models/locations_list_model.dart';
import 'package:weader/features/locations/data/repository/locations_repository_impl.dart';
import 'package:weader/features/locations/domain/entities/locations_list.dart';

class MockLocationsDataSource extends Mock implements LocationsDataSource {}

void main() {
  LocationsRepositoryImpl repository;
  MockLocationsDataSource mockLocationsDataSource;

  setUp(() {
    mockLocationsDataSource = MockLocationsDataSource();
    repository = LocationsRepositoryImpl(
      dataSource: mockLocationsDataSource,
    );
  });

  group('getLocationsList', () {
    final tQueryString = 'bengaluru';
    final tLocationsListModel = LocationsListModel(
      locationsList: [
        LocationModel(
          address: 'Karnataka, India',
          displayName: 'Bengaluru',
          latitude: 1.0,
          longitude: 1.0,
        ),
      ],
    );
    final LocationsList tLocationsList = tLocationsListModel;

    group('getLocationsList', () {
      test(
        'should return data when the call to data source is successful',
        () async {
          // arrange
          when(mockLocationsDataSource.getLocationsList(tQueryString))
              .thenAnswer((_) async => tLocationsListModel);
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
          address: 'Karnataka, India',
          displayName: 'Bengaluru',
          latitude: 1.0,
          longitude: 1.0,
        ),
      ],
    );
    final LocationsList tLocationsList = tLocationsListModel;

    test(
      'should return remote data when the call to device location package is successful',
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
}
