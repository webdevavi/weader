import 'dart:convert';
import 'package:Weader/core/entities/entities.dart';
import 'package:Weader/core/models/models.dart';
import 'package:Weader/core/util/datetime_converter.dart';
import 'package:timezone/timezone.dart';
import 'package:flutter/services.dart';

import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/fixture_reader.dart';
import '../../fixtures/weather_models_fixture.dart';

void main() {
  Future<void> initTZ() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    var byteData = await rootBundle.load('packages/timezone/data/2020a.tzf');
    initializeDatabase(byteData.buffer.asUint8List());
  }

  DateTimeConverter dateTimeConverter;

  setUp(() async {
    await initTZ();
    dateTimeConverter = DateTimeConverter();
  });

  test(
    'should be a subclass of Full Weather entity',
    () async {
      // assert
      expect(tFullWeatherModel, isA<FullWeather>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model',
      () async {
        // arrange
        final jsonMap = json.decode(fixture('weather_fixture.json'));
        // act
        final result = FullWeatherModel.fromJson(
          json: jsonMap,
          dateTimeConverter: dateTimeConverter,
        );
        // assert
        expect(result, tFullWeatherModel);
      },
    );
  });
}
