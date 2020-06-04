import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:weader/core/error/failures.dart';
import 'package:weader/features/weather/domain/usecases/get_weather.dart';
import './bloc.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetWeather getWeather;

  WeatherBloc(this.getWeather) : assert(getWeather != null);

  @override
  WeatherState get initialState => Empty();

  @override
  Stream<WeatherState> mapEventToState(
    WeatherEvent event,
  ) async* {
    if (event is GetWeatherEvent) {
      yield Loading();

      final weatherEither = await getWeather(
        Params(
          latitude: event.latitude,
          longitude: event.longitude,
        ),
      );

      yield* weatherEither.fold((failure) async* {
        yield Error(message: mapFailureToMessage(failure));
      }, (weather) async* {
        yield Loaded(weather: weather);
      });
    }
  }
}
