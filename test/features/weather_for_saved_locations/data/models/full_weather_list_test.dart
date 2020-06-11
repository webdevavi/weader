import 'package:Weader/features/weather_for_saved_locations/domain/entities/full_weather_list.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Weader/core/entities/entities.dart';

import '../../../../fixtures/weather_models_fixture.dart';

void main() {
  final FullWeather tFullWeather = tFullWeatherModel;
  final tFullWeatherList = FullWeatherList(fullWeatherList: [tFullWeather]);

  test(
    'should be a subclass of FullWeatherList enitity',
    () async {
      // assert
      expect(
        tFullWeatherList,
        isA<FullWeatherList>(),
      );
    },
  );
}
