import 'package:Weader/core/data_sources/weather_remote_data_source.dart';
import 'package:Weader/core/entities/entities.dart';
import 'package:Weader/features/weather_for_saved_locations/data/repositories/weather_for_saved_locations_repository_impl.dart';
import 'package:Weader/features/weather_for_saved_locations/domain/entities/full_weather_list.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:Weader/core/error/exception.dart';
import 'package:Weader/core/error/failures.dart';
import 'package:Weader/core/network/network_info.dart';

import '../../../../fixtures/weather_models_fixture.dart';

class MockRemoteDataSource extends Mock implements WeatherRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  WeatherForSavedLocationsRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = WeatherForSavedLocationsRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group(
    'getWeatherForSavedLocations',
    () {
      final tLatitude = 1.0;
      final tLongitude = 1.0;
      final tLocationPosition = LocationPosition(
        latitude: tLatitude,
        longitude: tLongitude,
      );
      final tWeatherModel = tFullWeatherModel;
      final FullWeather tFullWeather = tWeatherModel;
      final tFullWeatherList = FullWeatherList(fullWeatherList: [tFullWeather]);

      test(
        'should check if the device is online',
        () async {
          // arrange
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(mockRemoteDataSource.getWeather(
            latitude: anyNamed("latitude"),
            longitude: anyNamed("longitude"),
          )).thenAnswer((_) async => tWeatherModel);
          // act
          repository.getWeatherForSavedLocations(
            locationPositions: [tLocationPosition],
          );
          // assert
          verify(mockNetworkInfo.isConnected);
        },
      );

      test(
        'should return network failure when device is offline',
        () async {
          // arrange
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
          // act
          final result = await repository.getWeatherForSavedLocations(
            locationPositions: [tLocationPosition],
          );
          // assert
          expect(result, equals(Left(NetworkFailure())));
        },
      );

      group(
        'device is online',
        () {
          setUp(() {
            when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          });
          test(
            'should return remote data when the call to remote data source is successfull',
            () async {
              // arrange
              when(mockRemoteDataSource.getWeather(
                latitude: anyNamed("latitude"),
                longitude: anyNamed("longitude"),
              )).thenAnswer((_) async => tWeatherModel);
              // act
              final result = await repository.getWeatherForSavedLocations(
                locationPositions: [tLocationPosition],
              );
              // assert
              verify(mockRemoteDataSource.getWeather(
                latitude: tLatitude,
                longitude: tLongitude,
              ));
              expect(result, Right(tFullWeatherList));
            },
          );

          test(
            'should return server failure when the call to remote data source is unsuccessful',
            () async {
              // arrange
              when(mockRemoteDataSource.getWeather(
                latitude: anyNamed("latitude"),
                longitude: anyNamed("longitude"),
              )).thenThrow(ServerException());
              // act
              final result = await repository.getWeatherForSavedLocations(
                locationPositions: [tLocationPosition],
              );
              // assert
              verify(mockRemoteDataSource.getWeather(
                latitude: tLatitude,
                longitude: tLongitude,
              ));
              expect(result, equals(Left(ServerFailure())));
            },
          );
        },
      );
    },
  );
}
