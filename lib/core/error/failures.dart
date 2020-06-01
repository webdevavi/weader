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
