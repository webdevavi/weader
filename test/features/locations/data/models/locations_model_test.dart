import 'package:flutter_test/flutter_test.dart';
import 'package:weader/features/locations/data/models/location_model.dart';
import 'package:weader/features/locations/data/models/locations_list_model.dart';
import 'package:weader/features/locations/domain/entities/locations_list.dart';

import '../../../../fixtures/fixtures.dart';

void main() {
  final tLocationModel = LocationModel(
    address: 'Bengaluru, Bengaluru Urban, Karnataka, India',
    displayName: 'Bengaluru',
    latitude: 12.9715987,
    longitude: 77.5945627,
  );
  final tLocationsListModel = LocationsListModel(
    locationsList: [tLocationModel],
  );
  final tJson = {
    "address": 'Bengaluru, Bengaluru Urban, Karnataka, India',
    "display_name": 'Bengaluru',
    "latitude": 12.9715987,
    "longitude": 77.5945627,
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
          // act
          final result = LocationsListModel.fromData(locationListFixture);
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
          final result = LocationsListModel.fromJson([tJson]);

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
            [tJson],
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
            tJson,
          );
        },
      );
    },
  );
}
