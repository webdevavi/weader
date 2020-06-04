import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weader/features/weather/domain/entities/weather_entities.dart';
import 'package:weader/features/weather/domain/repositories/weather_repository.dart';
import 'package:weader/features/weather/domain/usecases/get_weather.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  GetWeather usecase;
  MockWeatherRepository mockWeatherRepository;

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
    usecase = GetWeather(mockWeatherRepository);
  });

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

  test(
    'should get full weather for the latitude and longitude from repository',
    () async {
      // arrange
      when(mockWeatherRepository.getWeather(
        latitude: anyNamed("latitude"),
        longitude: anyNamed("longitude"),
      )).thenAnswer((_) async => Right(tFullWeather));
      // act
      final result = await usecase(Params(
        latitude: tLatitude,
        longitude: tLongitude,
      ));
      // assert
      expect(result, Right(tFullWeather));
      verify(mockWeatherRepository.getWeather(
        latitude: tLatitude,
        longitude: tLongitude,
      ));
      verifyNoMoreInteractions(mockWeatherRepository);
    },
  );
}
