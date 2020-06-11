import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Weader/core/error/exception.dart';
import 'package:matcher/matcher.dart';
import 'package:Weader/core/models/models.dart';
import 'package:Weader/features/save_locations/data/data_sources/save_locations_local_data_source.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  SaveLocationsLocalDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = SaveLocationsLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
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

  group(
    'saveLocation',
    () {
      final tLocationModel = LocationModel(
        id: "cdef4a60-a821-11ea-fbdc-4fc75fc69aa5",
        address: 'Bengaluru, Bengaluru Urban, Karnataka, India',
        displayName: 'Bengaluru',
        latitude: 12.9715987,
        longitude: 77.5945627,
      );

      test(
        'should call SharedPrefrences to set new locations list after ',
        () async {
          // act
          dataSource.saveLocation(tLocationsListModel);
          // assert
          final expectedJsonString = json.encode(tLocationsListModel.toJson());
          verify(mockSharedPreferences.setString(
            SAVED_LOCATIONS_LIST,
            expectedJsonString,
          ));
        },
      );

      test(
        'should throw UnexpectedException when saving data fails',
        () async {
          // arrange
          when(mockSharedPreferences.setString(any, any))
              .thenAnswer((_) async => false);
          // assert
          expect(
            () => dataSource.saveLocation(tLocationsListModel),
            throwsA(TypeMatcher<UnexpectedException>()),
          );
        },
      );
    },
  );

  group('getSavedLocationsList', () {
    test(
      'should return saved locations list from SharedPreferences if there is one',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any)).thenReturn(
          fixture('recently_searched_locations_list.json'),
        );
        // act
        final result = await dataSource.getSavedLocationsList();
        // assert
        verify(mockSharedPreferences.getString(SAVED_LOCATIONS_LIST));
        expect(result, equals(tLocationsListModel));
      },
    );

    test(
      'should throw [UnexpectedException] for any exception',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any)).thenThrow(
          PlatformException(
            code: "101",
          ),
        );
        // assert
        expect(
          () => dataSource.getSavedLocationsList(),
          throwsA(TypeMatcher<NoLocalDataException>()),
        );
      },
    );
  });

  group(
    'deleteSavedLocation',
    () {
      final tId = "cdef4a60-a821-11ea-fbdc-4fc75fc69aa5";
      final tRecentlySearchedLocationsList = [
        {
          "id": "cdef4a60-a821-11ea-fbdc-4fc75fc69aa5",
          "address": "Bengaluru, Bengaluru Urban, Karnataka, India",
          "display_name": "Bengaluru",
          "latitude": 12.9715987,
          "longitude": 77.5945627
        },
        {
          "id": "cdef4a80-a821-11ea-fbdc-4fc75fc69aa5",
          "address": "Bengaluru, Bengaluru Urban, Karnataka, India",
          "display_name": "Bengaluru",
          "latitude": 12.9715987,
          "longitude": 77.5945627
        }
      ];

      final tNewRecentlySearchedLocationsList = LocationsListModel(
        locationsList: [
          LocationModel(
            id: "cdef4a80-a821-11ea-fbdc-4fc75fc69aa5",
            address: 'Bengaluru, Bengaluru Urban, Karnataka, India',
            displayName: 'Bengaluru',
            latitude: 12.9715987,
            longitude: 77.5945627,
          ),
        ],
      );

      test(
        'should call shared preferences to get saved locations list from SharedPreferences if there is one',
        () async {
          // arrange
          when(mockSharedPreferences.getString(any)).thenReturn(
            json.encode(tRecentlySearchedLocationsList),
          );
          // act
          dataSource.deleteSavedLocation(tId);
          // assert
          verify(mockSharedPreferences.getString(SAVED_LOCATIONS_LIST));
        },
      );

      test(
        '''should call shared preferences to set saved locations list 
        to SharedPreferences after removing the location model containing the id passed''',
        () async {
          // arrange
          when(mockSharedPreferences.getString(any)).thenReturn(
            json.encode(tRecentlySearchedLocationsList),
          );
          // act
          dataSource.deleteSavedLocation(tId);
          // assert
          final expectedJsonString =
              json.encode(tNewRecentlySearchedLocationsList.toJson());
          verify(
            mockSharedPreferences.setString(
              SAVED_LOCATIONS_LIST,
              expectedJsonString,
            ),
          );
        },
      );

      test(
        'should return new saved locations list',
        () async {
          // arrange
          when(mockSharedPreferences.getString(any)).thenReturn(
            json.encode(tRecentlySearchedLocationsList),
          );
          // act
          final result = await dataSource.deleteSavedLocation(tId);
          // assert
          expect(
            result,
            tNewRecentlySearchedLocationsList,
          );
        },
      );

      test(
        'should throw NoLocalDataException when there is no saved locations list data',
        () async {
          // arrange
          when(mockSharedPreferences.getString(any)).thenReturn(null);
          // assert
          expect(
            () => dataSource.deleteSavedLocation(tId),
            throwsA(TypeMatcher<NoLocalDataException>()),
          );
        },
      );

      test(
        'should throw UnexpectedException when clearing data fails',
        () async {
          // arrange
          when(mockSharedPreferences.getString(any)).thenReturn(
            json.encode(tRecentlySearchedLocationsList),
          ); //
          when(mockSharedPreferences.setString(any, any))
              .thenAnswer((_) async => false); // assert
          expect(
            () => dataSource.deleteSavedLocation(tId),
            throwsA(TypeMatcher<UnexpectedException>()),
          );
        },
      );
    },
  );

  group(
    'deleteAllSavedLocationsList',
    () {
      test(
        'should call SharedPrefrences to remove all saved locations list',
        () async {
          // arrange
          when(mockSharedPreferences.remove(any))
              .thenAnswer((_) async => Future.value(true));
          // act
          dataSource.deleteAllSavedLocations();
          // assert
          verify(mockSharedPreferences.remove(SAVED_LOCATIONS_LIST));
        },
      );

      test(
        'should throw UnexpectedException when clearing data fails',
        () async {
          // arrange
          when(mockSharedPreferences.remove(any))
              .thenAnswer((_) async => Future.value(false));
          // assert
          expect(
            () => dataSource.deleteAllSavedLocations(),
            throwsA(TypeMatcher<UnexpectedException>()),
          );
        },
      );
    },
  );
}
