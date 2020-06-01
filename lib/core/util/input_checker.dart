import 'package:dartz/dartz.dart';

import '../error/failures.dart';

class InputChecker {
  Either<Failure, String> checkNull(String input) {
    if (input != null && input.length > 0)
      return Right(input);
    else
      return Left(InvalidInputFailure());
  }
}

class InvalidInputFailure extends Failure {
  @override
  List<Object> get props => [];
}
