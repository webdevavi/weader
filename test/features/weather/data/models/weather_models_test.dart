import 'dart:convert';
import 'package:timezone/timezone.dart';
import 'package:flutter/services.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:weader/features/weather/data/models/weather_models.dart';
import 'package:weader/features/weather/domain/entities/weather_entities.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../../../../fixtures/weather_models_fixture.dart';

void main() {
  Future<void> initTZ() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    var byteData = await rootBundle.load('packages/timezone/data/2020a.tzf');
    initializeDatabase(byteData.buffer.asUint8List());
  }

  test(
    'should be a subclass of Full Weather entity',
    () async {
      // assert
      expect(tFullWeatherModel, isA<FullWeather>());
    },
  );

  group('fromJson', () {
    setUp(() async {
      await initTZ();
    });
    test(
      'should return a valid model',
      () async {
        // arrange
        final jsonMap = json.decode(fixture('weather_fixture.json'));
        // act
        final result = FullWeatherModel.fromJson(jsonMap);
        // assert
        expect(result, tFullWeatherModel);
      },
    );
  });
}
