import 'package:flutter_test/flutter_test.dart';
import 'package:weader/features/locations/data/models/location_model.dart';
import 'package:weader/features/locations/data/models/locations_list_model.dart';
import 'package:weader/features/locations/domain/entities/locations_list.dart';

import '../../../../fixtures/fixtures.dart';

void main() {
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

  test(
    'should be a subclass of LocationsList enitity',
    () async {
      // assert
      expect(tLocationsListModel, isA<LocationsList>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model',
      () async {
        // act
        final result = LocationsListModel.fromData(locationListFixture);
        // assert
        expect(result, tLocationsListModel);
      },
    );
  });
}
