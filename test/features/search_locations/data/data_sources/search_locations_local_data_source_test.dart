import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Weader/core/error/exception.dart';
import 'package:matcher/matcher.dart';
import 'package:Weader/core/models/models.dart';
import 'package:Weader/features/search_locations/data/data_sources/search_locations_local_data_source.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  SearchLocationsLocalDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = SearchLocationsLocalDataSourceImpl(
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
    'getRecentlySearchedLocationsList',
    () {
      test(
        'should return recently searched locations list from SharedPreferences if there is one',
        () async {
          // arrange
          when(mockSharedPreferences.getString(any)).thenReturn(
            fixture('recently_searched_locations_list.json'),
          );
          // act
          final result = await dataSource.getRecentlySearchedLocationsList();
          // assert
          verify(mockSharedPreferences
              .getString(RECENTLY_SEARCHED_LOCATIONS_LIST));
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
            () => dataSource.getRecentlySearchedLocationsList(),
            throwsA(TypeMatcher<NoLocalDataException>()),
          );
        },
      );
    },
  );

  group(
    'setRecentlySearchedLocationsList',
    () {
      test(
        'should call SharedPrefrences to save recently searched locations list',
        () async {
          // act
          dataSource.setRecentlySearchedLocationsList(tLocationsListModel);
          // assert
          final expectedJsonString = json.encode(tLocationsListModel);
          verify(mockSharedPreferences.setString(
            RECENTLY_SEARCHED_LOCATIONS_LIST,
            expectedJsonString,
          ));
        },
      );
    },
  );

  group(
    'clearOneRecentlySearchedLocation',
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
        'should call shared preferences to get recently searched locations list from SharedPreferences if there is one',
        () async {
          // arrange
          when(mockSharedPreferences.getString(any)).thenReturn(
            json.encode(tRecentlySearchedLocationsList),
          );
          // act
          dataSource.clearOneRecentlySearchedLocation(tId);
          // assert
          verify(mockSharedPreferences
              .getString(RECENTLY_SEARCHED_LOCATIONS_LIST));
        },
      );

      test(
        '''should call shared preferences to set recently searched locations list 
        to SharedPreferences after removing the location model containing the id passed''',
        () async {
          // arrange
          when(mockSharedPreferences.getString(any)).thenReturn(
            json.encode(tRecentlySearchedLocationsList),
          );
          // act
          dataSource.clearOneRecentlySearchedLocation(tId);
          // assert
          final expectedJsonString =
              json.encode(tNewRecentlySearchedLocationsList.toJson());
          verify(
            mockSharedPreferences.setString(
              RECENTLY_SEARCHED_LOCATIONS_LIST,
              expectedJsonString,
            ),
          );
        },
      );

      test(
        'should return new recently searched locations list',
        () async {
          // arrange
          when(mockSharedPreferences.getString(any)).thenReturn(
            json.encode(tRecentlySearchedLocationsList),
          );
          // act
          final result = await dataSource.clearOneRecentlySearchedLocation(tId);
          // assert
          expect(
            result,
            tNewRecentlySearchedLocationsList,
          );
        },
      );

      test(
        'should throw NoLocalDataException when there is no recently searched locations list data',
        () async {
          // arrange
          when(mockSharedPreferences.getString(any)).thenReturn(null);
          // assert
          expect(
            () => dataSource.clearOneRecentlySearchedLocation(tId),
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
            () => dataSource.clearOneRecentlySearchedLocation(tId),
            throwsA(TypeMatcher<UnexpectedException>()),
          );
        },
      );
    },
  );

  group(
    'clearAllRecentlySearchedLocation',
    () {
      test(
        'should call SharedPrefrences to remove all recently searched locations list',
        () async {
          // arrange
          when(mockSharedPreferences.remove(any))
              .thenAnswer((_) async => Future.value(true));
          // act
          dataSource.clearAllRecentlySearchedLocation();
          // assert
          verify(
              mockSharedPreferences.remove(RECENTLY_SEARCHED_LOCATIONS_LIST));
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
            () => dataSource.clearAllRecentlySearchedLocation(),
            throwsA(TypeMatcher<UnexpectedException>()),
          );
        },
      );
    },
  );
}
