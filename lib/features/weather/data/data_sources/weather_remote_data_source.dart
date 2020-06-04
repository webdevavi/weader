import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:weader/core/error/exception.dart';

import '../models/weather_models.dart';

abstract class WeatherRemoteDataSource {
  /// Calls the http://openweathermap.org endpoint.
  ///
  /// Throws a [Server Exception] for all error codes.
  Future<FullWeatherModel> getWeather({
    double latitude,
    double longitude,
  });
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final http.Client client;

  WeatherRemoteDataSourceImpl({
    @required this.client,
  });
  @override
  Future<FullWeatherModel> getWeather(
      {double latitude, double longitude}) async {
    final queries = {
      "lat": latitude.toString(),
      "lon": longitude.toString(),
      "units": "metric",
      "exclude": "minutely",
      "appid": "b3a2e8e9577ff98b717f6a07724553aa",
    };

    final url = Uri.https(
      "api.openweathermap.org",
      "data/2.5/onecall",
      queries,
    );

    final response = await client.get(url);

    if (response.statusCode == 200)
      return FullWeatherModel.fromJson(
        json.decode(
          response.body,
        ),
      );
    else
      throw ServerException();
  }
}
