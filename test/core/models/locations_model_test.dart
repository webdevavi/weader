import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:Weader/core/entities/entities.dart';
import 'package:Weader/core/models/models.dart';
import 'package:Weader/core/util/unique_id_generator.dart';

import '../../fixtures/fixture_reader.dart';
import '../../fixtures/fixtures.dart';

class MockUniqueIdGenerator extends Mock implements UniqueIdGenerator {}

void main() {
  MockUniqueIdGenerator mockUniqueIdGenerator;

  setUp(() {
    mockUniqueIdGenerator = MockUniqueIdGenerator();
  });
  final tLocationModel = LocationModel(
    id: "cdef4a60-a821-11ea-fbdc-4fc75fc69aa5",
    address: 'Bengaluru, Bengaluru Urban, Karnataka, India',
    displayName: 'Bengaluru',
    latitude: 12.9715987,
    longitude: 77.5945627,
  );
  final tLocationsListModel = LocationsListModel(
    locationsList: [tLocationModel],
  );
  final tJsonList =
      json.decode(fixture('recently_searched_locations_list.json'));
  final tJsonmap = {
    "id": "cdef4a60-a821-11ea-fbdc-4fc75fc69aa5",
    "address": "Bengaluru, Bengaluru Urban, Karnataka, India",
    "display_name": "Bengaluru",
    "latitude": 12.9715987,
    "longitude": 77.5945627
  };

  test(
    'should be a subclass of LocationsList enitity',
    () async {
      // assert
      expect(
        tLocationsListModel,
        isA<LocationsList>(),
      );
    },
  );

  group(
    'LocationsListModel.fromData',
    () {
      test(
        'should return a valid model',
        () async {
          // arrange
          when(mockUniqueIdGenerator.getId).thenReturn(
            "cdef4a60-a821-11ea-fbdc-4fc75fc69aa5",
          );
          // act
          final result = LocationsListModel.fromData(
            data: locationListFixture,
            uniqueIdGenerator: mockUniqueIdGenerator,
          );
          // assert
          expect(
            result,
            tLocationsListModel,
          );
        },
      );
    },
  );

  group(
    'LocationsListModel.fromJson',
    () {
      test(
        'should return a valid model',
        () async {
          // act
          final result = LocationsListModel.fromJson(tJsonList);

          //assert
          expect(
            result,
            tLocationsListModel,
          );
        },
      );
    },
  );

  group(
    'LocationsListModel.toJson',
    () {
      test(
        'should return a JSON list container proper data',
        () async {
          // act
          final result = tLocationsListModel.toJson();

          // assert
          expect(
            result,
            tJsonList,
          );
        },
      );
    },
  );

  group(
    'LocationsModel.toJson',
    () {
      test(
        'should return a JSON map containing the proper data',
        () async {
          // arrange

          // act
          final result = tLocationModel.toJson();
          // assert

          expect(
            result,
            tJsonmap,
          );
        },
      );
    },
  );
}
