import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weader/core/util/input_checker.dart';

void main() {
  InputChecker inputChecker;

  setUp(() {
    inputChecker = InputChecker();
  });

  group('checkNull', () {
    test(
      'should return inout string',
      () {
        // arrange
        final String input = 'abc';
        // act
        final result = inputChecker.checkNull(input);
        // assert
        expect(result, Right('abc'));
      },
    );

    test(
      'should return invalid inout failure when input string is empty',
      () {
        // arrange
        final String input = '';
        // act
        final result = inputChecker.checkNull(input);
        // assert
        expect(result, Left(InvalidInputFailure()));
      },
    );

    test(
      'should return invalid inout failure when input string is null',
      () {
        // arrange
        final String input = null;
        // act
        final result = inputChecker.checkNull(input);
        // assert
        expect(result, Left(InvalidInputFailure()));
      },
    );
  });
}
