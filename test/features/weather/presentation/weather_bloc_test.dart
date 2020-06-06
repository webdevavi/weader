import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:weader/core/error/failures.dart';
import 'package:weader/features/weather/domain/entities/weather_entities.dart';
import 'package:weader/features/weather/presentation/bloc/bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:weader/features/weather/domain/usecases/get_weather.dart';

class MockGetWeather extends Mock implements GetWeather {}

void main() {
  WeatherBloc bloc;
  MockGetWeather mockGetWeather;

  setUp(() {
    mockGetWeather = MockGetWeather();

    bloc = WeatherBloc(mockGetWeather);
  });

  group('WeatherBloc', () {
    test(
      'initial state should be empty',
      () {
        expect(bloc.initialState, equals(WeatherEmpty()));
      },
    );

    group(
      'getWeatherEvent',
      () {
        final double tLatitude = 1.0;
        final double tLongitude = 1.0;
        final Weather tWeather = Weather(
          dateTime: "",
          dateTimeIn24: "",
          timezoneSpecificDateTime: "",
          timezoneSpecificDateTimeIn24: "",
          temperature: "",
          temperatureAsF: "",
          feelsLikeTemperature: "",
          feelsLikeTemperatureAsF: "",
          windSpeed: "",
          windSpeedInMPH: "",
          description: "",
          icon: "",
          day: "",
          timezoneSpecificDay: "",
          temperatureIcon: "",
        );
        final DailyWeather tDailyWeather = DailyWeather(
          dateTime: "",
          timezoneSpecificDateTime: "",
          sunrise: "",
          sunriseIn24: "",
          timezoneSpecificSunrise: "",
          timezoneSpecificSunriseIn24: "",
          sunset: "",
          sunsetIn24: "",
          timezoneSpecificSunset: "",
          timezoneSpecificSunsetIn24: "",
          dayTemperature: "",
          dayTemperatureAsF: "",
          nightTemperature: "",
          nightTemperatureAsF: "",
          eveTemperature: "",
          eveTemperatureAsF: "",
          mornTemperature: "",
          mornTemperatureAsF: "",
          minTemperature: "",
          minTemperatureAsF: "",
          maxTemperature: "",
          maxTemperatureAsF: "",
          dayFeelsLikeTemperature: "",
          dayFeelsLikeTemperatureAsF: "",
          nightFeelsLikeTemperature: "",
          nightFeelsLikeTemperatureAsF: "",
          eveFeelsLikeTemperature: "",
          eveFeelsLikeTemperatureAsF: "",
          mornFeelsLikeTemperature: "",
          mornFeelsLikeTemperatureAsF: "",
          windSpeed: "",
          windSpeedInMPH: "",
          description: "",
          icon: "",
          temperatureIconDay: "",
          temperatureIconNight: "",
          temperatureIconEve: "",
          temperatureIconMorn: "",
          temperatureIconMax: "",
          temperatureIconMin: "",
        );

        final FullWeather tFullWeather = FullWeather(
          timezone: "",
          daytime: "",
          timezoneSpecificDaytime: "",
          sunrise: "",
          sunriseIn24: "",
          sunset: "",
          sunsetIn24: "",
          timezoneSpecificSunrise: "",
          timezoneSpecificSunriseIn24: "",
          timezoneSpecificSunset: "",
          timezoneSpecificSunsetIn24: "",
          current: tWeather,
          hourly: [tWeather],
          daily: [tDailyWeather],
        );

        blocTest(
          'should get data from the get weather usecase',
          build: () async {
            when(mockGetWeather(any))
                .thenAnswer((_) async => Right(tFullWeather));
            return WeatherBloc(mockGetWeather);
          },
          act: (bloc) => bloc.add(
            GetWeatherEvent(
              latitude: tLatitude,
              longitude: tLongitude,
            ),
          ),
          verify: (_) async => verify(
            mockGetWeather(
              Params(latitude: tLatitude, longitude: tLongitude),
            ),
          ),
        );

        blocTest(
          'should emit [Loading, Loaded] when data is gotten successfully',
          build: () async {
            when(mockGetWeather(any))
                .thenAnswer((_) async => Right(tFullWeather));
            return WeatherBloc(mockGetWeather);
          },
          act: (bloc) => bloc.add(
            GetWeatherEvent(
              latitude: tLatitude,
              longitude: tLongitude,
            ),
          ),
          expect: [
            WeatherLoading(),
            WeatherLoaded(weather: tFullWeather),
          ],
        );

        blocTest(
          'should emit [Loading, Error] when getting data fails',
          build: () async {
            when(mockGetWeather(any)).thenAnswer(
              (_) async => Left(
                ServerFailure(),
              ),
            );
            return WeatherBloc(mockGetWeather);
          },
          act: (bloc) => bloc.add(
            GetWeatherEvent(
              latitude: tLatitude,
              longitude: tLongitude,
            ),
          ),
          expect: [
            WeatherLoading(),
            WeatherError(
              message: SERVER_FAILURE_MESSAGE,
            ),
          ],
        );
      },
    );
  });
}
