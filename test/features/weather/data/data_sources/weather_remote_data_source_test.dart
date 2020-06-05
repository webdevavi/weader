import 'package:matcher/matcher.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/timezone.dart';
import 'package:weader/core/error/exception.dart';
import 'package:weader/core/keys/keys.dart';
import 'package:weader/features/weather/data/data_sources/weather_remote_data_source.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../../../../fixtures/weather_models_fixture.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  WeatherRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  Future<void> initTZ() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    var byteData = await rootBundle.load('packages/timezone/data/2020a.tzf');
    initializeDatabase(byteData.buffer.asUint8List());
  }

  setUp(() async {
    await initTZ();
    mockHttpClient = MockHttpClient();
    dataSource = WeatherRemoteDataSourceImpl(
      client: mockHttpClient,
    );
  });

  final tLatitude = 1.0;
  final tLongitude = 1.0;
  final tWeatherModel = tFullWeatherModel;

  test(
    '''should perform GET request on a URL with latitude and longitude
    being the endpoint and with proper query parameters''',
    () async {
      // arrange
      await initTZ();
      when(mockHttpClient.get(any)).thenAnswer((_) async => http.Response(
            fixture('weather_fixture.json'),
            200,
          ));
      // act
      dataSource.getWeather(
        latitude: tLatitude,
        longitude: tLongitude,
      );
      // assert
      final queries = {
        "lat": tLatitude.toString(),
        "lon": tLongitude.toString(),
        "units": "metric",
        "exclude": "minutely",
        "appid": OPENWEATHERMAP
      };
      final url = Uri.https(
        "api.openweathermap.org",
        "data/2.5/onecall",
        queries,
      );
      verify(mockHttpClient.get(url));
    },
  );

  test(
    'should return Weather when the response code is 200 (successful)',
    () async {
      // arrange
      when(mockHttpClient.get(any)).thenAnswer(
        (_) async => http.Response(fixture('weather_fixture.json'), 200),
      );
      // act
      final result = await dataSource.getWeather(
        latitude: tLatitude,
        longitude: tLongitude,
      );
      // assert
      expect(result, equals(tWeatherModel));
    },
  );

  test(
    'should throw a server exception when response code is not 200 (unsuccessful)',
    () async {
      // arrange
      when(mockHttpClient.get(any)).thenAnswer(
        (_) async => http.Response("Something went wrong", 404),
      );
      // act
      final call = dataSource.getWeather;
      // assert
      expect(
          () => call(
                latitude: tLatitude,
                longitude: tLongitude,
              ),
          throwsA(TypeMatcher<ServerException>()));
    },
  );
}
