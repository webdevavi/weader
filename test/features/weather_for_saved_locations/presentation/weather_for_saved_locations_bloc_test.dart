import 'package:Weader/core/entities/entities.dart';
import 'package:Weader/features/weather_for_saved_locations/domain/entities/full_weather_list.dart';
import 'package:Weader/features/weather_for_saved_locations/domain/usecases/get_weather_for_saved_locations.dart';
import 'package:Weader/features/weather_for_saved_locations/presentation/bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:Weader/core/error/failures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

import '../../../fixtures/weather_models_fixture.dart';

class MockGetWeatherForSavedLocations extends Mock
    implements GetWeatherForSavedLocations {}

void main() {
  WeatherForSavedLocationsBloc bloc;
  MockGetWeatherForSavedLocations mockGetWeatherForSavedLocations;

  setUp(() {
    mockGetWeatherForSavedLocations = MockGetWeatherForSavedLocations();

    bloc = WeatherForSavedLocationsBloc(mockGetWeatherForSavedLocations);
  });

  group('WeatherForSavedLocationsBloc', () {
    test(
      'initial state should be empty',
      () {
        expect(bloc.initialState, equals(WeatherForSavedLocationsEmpty()));
      },
    );

    group(
      'getWeatherEvent',
      () {
        final tLatitude = 1.0;
        final tLongitude = 1.0;
        final tLocationPosition = LocationPosition(
          latitude: tLatitude,
          longitude: tLongitude,
        );
        final tWeatherModel = tFullWeatherModel;
        final FullWeather tFullWeather = tWeatherModel;
        final tFullWeatherList =
            FullWeatherList(fullWeatherList: [tFullWeather]);

        blocTest(
          'should get data from the get weather usecase',
          build: () async {
            when(mockGetWeatherForSavedLocations(any))
                .thenAnswer((_) async => Right(tFullWeatherList));
            return WeatherForSavedLocationsBloc(
              mockGetWeatherForSavedLocations,
            );
          },
          act: (bloc) => bloc.add(
            GetWeatherForSavedLocationsEvent([tLocationPosition]),
          ),
          verify: (_) async => verify(
            mockGetWeatherForSavedLocations(
              GetWeatherForSavedLocationsParams([tLocationPosition]),
            ),
          ),
        );

        blocTest(
          'should emit [Loading, Loaded] when data is gotten successfully',
          build: () async {
            when(mockGetWeatherForSavedLocations(any))
                .thenAnswer((_) async => Right(tFullWeatherList));
            return WeatherForSavedLocationsBloc(
              mockGetWeatherForSavedLocations,
            );
          },
          act: (bloc) => bloc.add(
            GetWeatherForSavedLocationsEvent([tLocationPosition]),
          ),
          expect: [
            WeatherForSavedLocationsLoading(),
            WeatherForSavedLocationsLoaded(fullWeatherList: tFullWeatherList),
          ],
        );

        blocTest(
          'should emit [Loading, Error] when getting data fails',
          build: () async {
            when(mockGetWeatherForSavedLocations(any)).thenAnswer(
              (_) async => Left(
                ServerFailure(),
              ),
            );
            return WeatherForSavedLocationsBloc(
              mockGetWeatherForSavedLocations,
            );
          },
          act: (bloc) => bloc.add(
            GetWeatherForSavedLocationsEvent([tLocationPosition]),
          ),
          expect: [
            WeatherForSavedLocationsLoading(),
            WeatherForSavedLocationsError(
              message: SERVER_FAILURE_MESSAGE,
            ),
          ],
        );
      },
    );
  });
}
