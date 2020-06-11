import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_weather_for_one_location.dart';
import 'bloc.dart';

class WeatherForOneLocationBloc
    extends Bloc<WeatherForOneLocationEvent, WeatherForOneLocationState> {
  final GetWeatherForOneLocation getWeatherForOneLocation;

  WeatherForOneLocationBloc(this.getWeatherForOneLocation)
      : assert(getWeatherForOneLocation != null);

  @override
  WeatherForOneLocationState get initialState => WeatherForOneLocationEmpty();

  @override
  Stream<WeatherForOneLocationState> mapEventToState(
    WeatherForOneLocationEvent event,
  ) async* {
    if (event is GetWeatherForOneLocationEvent) {
      yield WeatherForOneLocationLoading();

      final weatherEither = await getWeatherForOneLocation(
        GetWeatherForOneLocationParams(
          latitude: event.latitude,
          longitude: event.longitude,
        ),
      );

      yield* weatherEither.fold((failure) async* {
        yield WeatherForOneLocationError(message: mapFailureToMessage(failure));
      }, (weather) async* {
        yield WeatherForOneLocationLoaded(weather: weather);
      });
    }
  }
}
