import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/weather_entities.dart';
import '../repositories/weather_repository.dart';

class GetWeather extends UseCase<FullWeather, Params> {
  final WeatherRepository repository;

  GetWeather(this.repository);

  @override
  Future<Either<Failure, FullWeather>> call(Params params) async {
    return await repository.getWeather(
        latitude: params.latitude, longitude: params.longitude);
  }
}

class Params extends Equatable {
  final double latitude;
  final double longitude;

  Params({
    @required this.latitude,
    @required this.longitude,
  });
  @override
  List<Object> get props => [
        latitude,
        longitude,
      ];
}
