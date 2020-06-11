import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/mockito.dart';
import 'package:Weader/core/error/exception.dart';
import 'package:Weader/core/models/models.dart';
import 'package:Weader/core/util/unique_id_generator.dart';
import 'package:matcher/matcher.dart';
import 'package:Weader/features/search_locations/data/data_sources/search_locations_remote_data_source.dart';

import '../../../../fixtures/fixtures.dart';

class MockGeolocator extends Mock implements Geolocator {}

class MockUniqueIdGenerator extends Mock implements UniqueIdGenerator {}

void main() {
  SearchLocationsRemoteDataSourceImpl dataSource;
  MockGeolocator mockGeolocator;
  MockUniqueIdGenerator mockUniqueIdGenerator;

  setUp(() {
    mockGeolocator = MockGeolocator();
    mockUniqueIdGenerator = MockUniqueIdGenerator();
    dataSource = SearchLocationsRemoteDataSourceImpl(
      uniqueIdGenerator: mockUniqueIdGenerator,
      geolocator: mockGeolocator,
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
          when(mockUniqueIdGenerator.getId).thenReturn(
            "cdef4a60-a821-11ea-fbdc-4fc75fc69aa5",
          );
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
}
