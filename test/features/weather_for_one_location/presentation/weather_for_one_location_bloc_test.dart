import 'package:Weader/core/entities/entities.dart';
import 'package:Weader/features/weather_for_one_location/domain/usecases/get_weather_for_one_location.dart';
import 'package:Weader/features/weather_for_one_location/presentation/bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:Weader/core/error/failures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

class MockGetWeatherForOneLocation extends Mock
    implements GetWeatherForOneLocation {}

void main() {
  WeatherForOneLocationBloc bloc;
  MockGetWeatherForOneLocation mockGetWeatherForOneLocation;

  setUp(() {
    mockGetWeatherForOneLocation = MockGetWeatherForOneLocation();

    bloc = WeatherForOneLocationBloc(mockGetWeatherForOneLocation);
  });

  group('WeatherBloc', () {
    test(
      'initial state should be empty',
      () {
        expect(bloc.initialState, equals(WeatherForOneLocationEmpty()));
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
            when(mockGetWeatherForOneLocation(any))
                .thenAnswer((_) async => Right(tFullWeather));
            return WeatherForOneLocationBloc(mockGetWeatherForOneLocation);
          },
          act: (bloc) => bloc.add(
            GetWeatherForOneLocationEvent(
              latitude: tLatitude,
              longitude: tLongitude,
            ),
          ),
          verify: (_) async => verify(
            mockGetWeatherForOneLocation(
              GetWeatherForOneLocationParams(
                latitude: tLatitude,
                longitude: tLongitude,
              ),
            ),
          ),
        );

        blocTest(
          'should emit [Loading, Loaded] when data is gotten successfully',
          build: () async {
            when(mockGetWeatherForOneLocation(any))
                .thenAnswer((_) async => Right(tFullWeather));
            return WeatherForOneLocationBloc(mockGetWeatherForOneLocation);
          },
          act: (bloc) => bloc.add(
            GetWeatherForOneLocationEvent(
              latitude: tLatitude,
              longitude: tLongitude,
            ),
          ),
          expect: [
            WeatherForOneLocationLoading(),
            WeatherForOneLocationLoaded(weather: tFullWeather),
          ],
        );

        blocTest(
          'should emit [Loading, Error] when getting data fails',
          build: () async {
            when(mockGetWeatherForOneLocation(any)).thenAnswer(
              (_) async => Left(
                ServerFailure(),
              ),
            );
            return WeatherForOneLocationBloc(mockGetWeatherForOneLocation);
          },
          act: (bloc) => bloc.add(
            GetWeatherForOneLocationEvent(
              latitude: tLatitude,
              longitude: tLongitude,
            ),
          ),
          expect: [
            WeatherForOneLocationLoading(),
            WeatherForOneLocationError(
              message: SERVER_FAILURE_MESSAGE,
            ),
          ],
        );
      },
    );
  });
}
