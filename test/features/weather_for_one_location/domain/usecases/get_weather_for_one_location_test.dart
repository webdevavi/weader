import 'package:Weader/core/entities/entities.dart';
import 'package:Weader/features/weather_for_one_location/domain/repositories/weather_for_one_location_repository.dart';
import 'package:Weader/features/weather_for_one_location/domain/usecases/get_weather_for_one_location.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockWeatherForOneLocationRepository extends Mock
    implements WeatherForOneLocationRepository {}

void main() {
  GetWeatherForOneLocation usecase;
  MockWeatherForOneLocationRepository mockWeatherForOneLocationRepository;

  setUp(() {
    mockWeatherForOneLocationRepository = MockWeatherForOneLocationRepository();
    usecase = GetWeatherForOneLocation(mockWeatherForOneLocationRepository);
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

  test(
    'should get full weather for the latitude and longitude from repository',
    () async {
      // arrange
      when(mockWeatherForOneLocationRepository.getWeather(
        latitude: anyNamed("latitude"),
        longitude: anyNamed("longitude"),
      )).thenAnswer((_) async => Right(tFullWeather));
      // act
      final result = await usecase(GetWeatherForOneLocationParams(
        latitude: tLatitude,
        longitude: tLongitude,
      ));
      // assert
      expect(result, Right(tFullWeather));
      verify(mockWeatherForOneLocationRepository.getWeather(
        latitude: tLatitude,
        longitude: tLongitude,
      ));
      verifyNoMoreInteractions(mockWeatherForOneLocationRepository);
    },
  );
}
