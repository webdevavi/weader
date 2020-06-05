import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:weader/features/time_aware_wallpaper/data/models/time_aware_wallpaper_model.dart';
import 'package:weader/features/time_aware_wallpaper/domain/entity/time_aware_wallpaper.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tTimeAwareWallpaperModel = TimeAwareWallpaperModel("url");

  test('should be a subclass of TimeAwareWallpaper entity', () {
    expect(tTimeAwareWallpaperModel, isA<TimeAwareWallpaper>());
  });

  group(
    'TimeAwareWallpaperModel.fromJson',
    () {
      test(
        'should return a valid model',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('time_aware_wallpaper.json'));
          // act
          final result = TimeAwareWallpaperModel.fromJson(jsonMap);
          // assert
          expect(result, tTimeAwareWallpaperModel);
        },
      );
    },
  );

  group(
    'TimeAwareWallpaperModel.toJson',
    () {
      test(
        'should return a JSON map containing the proper data',
        () async {
          // act
          final result = tTimeAwareWallpaperModel.toJson();
          // assert
          final expectedJsonMap = {
            "url": "url",
          };
          expect(result, expectedJsonMap);
        },
      );
    },
  );
}
