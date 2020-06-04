import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/mockito.dart';
import 'package:weader/core/error/exception.dart';
import 'package:weader/features/locations/data/data_sources/locations_data_source.dart';
import 'package:weader/features/locations/data/models/location_model.dart';
import 'package:weader/features/locations/data/models/locations_list_model.dart';
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixtures.dart';

class MockGeolocator extends Mock implements Geolocator {}

void main() {
  LocationsDataSourceImpl dataSource;
  MockGeolocator mockGeolocator;

  setUp(() {
    mockGeolocator = MockGeolocator();
    dataSource = LocationsDataSourceImpl(
      geolocator: mockGeolocator,
    );
  });

  final tLocationsListModel = LocationsListModel(
    locationsList: [
      LocationModel(
        address: 'Bengaluru, Bengaluru Urban, Karnataka, India',
        displayName: 'Bengaluru',
        latitude: 12.9715987,
        longitude: 77.5945627,
      ),
    ],
  );

  final locationsList = Future.value(locationListFixture);

  group(
    'getLocationsList',
    () {
      final String tQueryString = 'bengaluru';
      test(
        'should return locations list for the query string',
        () async {
          // arrange

          when(mockGeolocator.placemarkFromAddress(any))
              .thenAnswer((_) => locationsList);

          // act
          final result = await dataSource.getLocationsList(tQueryString);
          // assert
          verify(mockGeolocator.placemarkFromAddress(tQueryString));
          expect(result, equals(tLocationsListModel));
        },
      );

      test(
        'should throw a Not Found Exception if there are no locations for the query',
        () async {
          // arrange
          when(mockGeolocator.placemarkFromAddress(any))
              .thenAnswer((_) => null);

          // act
          final call = dataSource.getLocationsList;
          // assert
          expect(() => call(tQueryString),
              throwsA(TypeMatcher<NotFoundException>()));
        },
      );
    },
  );

  group('getDeviceLocationsList', () {
    final position = Future<Position>.value(
      Position(
        longitude: 77.5945627,
        latitude: 12.9715987,
      ),
    );

    test(
      'should call mockGeolocator.placemarkFromCoordinates if mockGeolocator.getCurrentPosition returns a Position object',
      () async {
        // arrange
        when(mockGeolocator.getCurrentPosition()).thenAnswer((_) => position);
        when(mockGeolocator.placemarkFromCoordinates(any, any))
            .thenAnswer((_) => locationsList);
        // act
        final result = await dataSource.getDeviceLocationsList();
        // assert
        verify(mockGeolocator.getCurrentPosition());
        expect(result, tLocationsListModel);
      },
    );

    test(
      'should throw a Not Found Exception if there are no locations for the query',
      () async {
        // arrange
        when(mockGeolocator.getCurrentPosition()).thenAnswer((_) => position);
        when(mockGeolocator.placemarkFromAddress(any)).thenAnswer((_) => null);

        // act
        final call = dataSource.getDeviceLocationsList;
        // assert
        expect(() => call(), throwsA(TypeMatcher<NotFoundException>()));
      },
    );

    test(
      'should throw a Device Location Exception if getCurrentPosition returns no Position',
      () async {
        // arrange
        when(mockGeolocator.getCurrentPosition()).thenAnswer((_) => null);
        when(mockGeolocator.placemarkFromAddress(any)).thenAnswer((_) => null);

        // act
        final call = dataSource.getDeviceLocationsList;
        // assert
        expect(() => call(), throwsA(TypeMatcher<DeviceLocationException>()));
      },
    );
  });
}
