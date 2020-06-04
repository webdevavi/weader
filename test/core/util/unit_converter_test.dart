import 'package:flutter_test/flutter_test.dart';
import 'package:weader/core/util/unit_converter.dart';

void main() {
  UnitConverter converter;

  setUp(() {
    converter = UnitConverter();
  });

  final int tCelsius = 0;
  final double tFahrenheit = 32;

  test(
    'should convert celsius into fahrenheit',
    () {
      // act
      final result = converter.convertToF(tCelsius);
      // assert
      expect(result, tFahrenheit);
    },
  );
}
