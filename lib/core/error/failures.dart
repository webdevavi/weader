import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {}

// General failures
class ServerFailure extends Failure {
  @override
  List<Object> get props => [];
}

class NetworkFailure extends Failure {
  @override
  List<Object> get props => [];
}

class CacheFailure extends Failure {
  @override
  List<Object> get props => [];
}

class DeviceLocationFailure extends Failure {
  @override
  List<Object> get props => [];
}

class NotFoundFailure extends Failure {
  @override
  List<Object> get props => [];
}

class InvalidInputFailure extends Failure {
  @override
  List<Object> get props => [];
}

class NoLocalDataFailure extends Failure {
  @override
  List<Object> get props => [];
}

class UnexpectedFailure extends Failure {
  @override
  List<Object> get props => [];
}

class LocationAlreadySavedFailure extends Failure {
  @override
  List<Object> get props => [];
}

const SERVER_FAILURE_MESSAGE = 'Server Error';
const NETWORK_FAILURE_MESSAGE = 'Network Error';
const CACHE_FAILURE_MESSAGE = 'Cache Error';
const NOT_FOUND_FAILURE_MESSAGE = 'Location Not Found';
const DEVICE_LOCATION_FAILURE_MESSAGE = 'Device Location Service Error';
const INVALID_INPUT_FAILURE_MESSAGE = 'Invalid Input';
const UNEXPECTED_FAILURE_MESSAGE = 'Unexpected Error';
const NO_LOCAL_DATA_FAILURE_MESSAGE = 'No Data';
const LOCATION_ALREADY_SAVED_FAILURE_MESSAGE = "The location is already saved";

String mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure:
      return SERVER_FAILURE_MESSAGE;
    case NetworkFailure:
      return NETWORK_FAILURE_MESSAGE;
    case CacheFailure:
      return CACHE_FAILURE_MESSAGE;
    case NotFoundFailure:
      return NOT_FOUND_FAILURE_MESSAGE;
    case DeviceLocationFailure:
      return DEVICE_LOCATION_FAILURE_MESSAGE;
    case InvalidInputFailure:
      return INVALID_INPUT_FAILURE_MESSAGE;
    case NoLocalDataFailure:
      return NO_LOCAL_DATA_FAILURE_MESSAGE;
    case LocationAlreadySavedFailure:
      return LOCATION_ALREADY_SAVED_FAILURE_MESSAGE;
    case UnexpectedFailure:
    default:
      return UNEXPECTED_FAILURE_MESSAGE;
  }
}
