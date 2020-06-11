import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/keys/keys.dart';
import '../models/time_aware_wallpaper_model.dart';

abstract class TimeAwareWallpaperRemoteDataSource {
  /// calls the api.unsplash.com/random endpoint
  ///
  /// throws a [Server Exception] for all error codes
  Future<TimeAwareWallpaperModel> getWallpaper(String time);
}

class TimeAwareWallpaperRemoteDataSourceImpl
    implements TimeAwareWallpaperRemoteDataSource {
  final http.Client client;

  TimeAwareWallpaperRemoteDataSourceImpl({
    @required this.client,
  });
  @override
  Future<TimeAwareWallpaperModel> getWallpaper(String time) async {
    final queries = {
      "query": time,
      "client_id": UNSPLASH,
      "orientation": "portrait",
    };
    final url = Uri.https(
      "api.unsplash.com",
      "photos/random",
      queries,
    );

    try {
      final response = await client.get(url);
      if (response.statusCode == 200)
        return TimeAwareWallpaperModel.fromJson(json.decode(response.body));
      else
        throw ServerException();
    } on Exception {
      throw ServerException();
    }
  }
}
