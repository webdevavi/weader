import 'package:Weader/core/entities/entities.dart';
import 'package:Weader/features/weather_for_saved_locations/domain/entities/full_weather_list.dart';
import 'package:Weader/features/weather_for_saved_locations/domain/repositories/weather_for_saved_locations_repository.dart';
import 'package:Weader/features/weather_for_saved_locations/domain/usecases/get_weather_for_saved_locations.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/weather_models_fixture.dart';

class MockWeatherForSavedLocationsRepository extends Mock
    implements WeatherForSavedLocationsRepository {}

void main() {
  GetWeatherForSavedLocations usecase;
  MockWeatherForSavedLocationsRepository mockWeatherForSavedLocationsRepository;

  setUp(() {
    mockWeatherForSavedLocationsRepository =
        MockWeatherForSavedLocationsRepository();
    usecase =
        GetWeatherForSavedLocations(mockWeatherForSavedLocationsRepository);
  });

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
    'should get full weather for the latitude and longitude from repository',
    () async {
      // arrange
      when(mockWeatherForSavedLocationsRepository.getWeatherForSavedLocations(
              locationPositions: [tLocationPosition]))
          .thenAnswer((_) async => Right(tFullWeatherList));
      // act
      final result = await usecase(GetWeatherForSavedLocationsParams(
        [tLocationPosition],
      ));
      // assert
      verify(
        mockWeatherForSavedLocationsRepository.getWeatherForSavedLocations(
            locationPositions: [tLocationPosition]),
      );
      expect(result, Right(tFullWeatherList));
      verifyNoMoreInteractions(mockWeatherForSavedLocationsRepository);
    },
  );
}
