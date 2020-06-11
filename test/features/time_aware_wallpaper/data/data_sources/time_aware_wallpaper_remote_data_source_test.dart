import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:Weader/core/error/exception.dart';
import 'package:Weader/core/keys/keys.dart';
import 'package:Weader/features/time_aware_wallpaper/data/datasources/time_aware_wallpaper_remote_data_source.dart';
import 'package:Weader/features/time_aware_wallpaper/data/models/time_aware_wallpaper_model.dart';
import 'package:matcher/matcher.dart';
import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  TimeAwareWallpaperRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TimeAwareWallpaperRemoteDataSourceImpl(
      client: mockHttpClient,
    );
  });
  final tTime = "morning";
  final tTimeAwareWallpaperModel = TimeAwareWallpaperModel("url");

  test(
    '''should perform GET request on a URL with time
    being the endpoint and with proper query parameters''',
    () async {
      // arrange
      when(mockHttpClient.get(any)).thenAnswer((_) async => http.Response(
            fixture('time_aware_wallpaper.json'),
            200,
          ));
      // act
      dataSource.getWallpaper(tTime);
      // assert
      final queries = {
        "query": tTime,
        "client_id": UNSPLASH,
        "orientation": "portrait",
      };
      final url = Uri.https(
        "api.unsplash.com",
        "photos/random",
        queries,
      );
      verify(mockHttpClient.get(url));
    },
  );

  test(
    'should return TimeAwareWallpaper when the response code is 200 (successful)',
    () async {
      // arrange
      when(mockHttpClient.get(any)).thenAnswer(
        (_) async => http.Response(fixture('time_aware_wallpaper.json'), 200),
      );
      // act
      final result = await dataSource.getWallpaper(tTime);
      // assert
      expect(result, equals(tTimeAwareWallpaperModel));
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
      final call = dataSource.getWallpaper;
      // assert
      expect(() => call(tTime), throwsA(TypeMatcher<ServerException>()));
    },
  );
}
