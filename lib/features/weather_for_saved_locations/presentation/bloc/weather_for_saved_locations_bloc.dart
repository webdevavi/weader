import 'dart:async';

import 'package:bloc/bloc.dart';

import './bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_weather_for_saved_locations.dart';

class WeatherForSavedLocationsBloc
    extends Bloc<WeatherForSavedLocationsEvent, WeatherForSavedLocationsState> {
  final GetWeatherForSavedLocations getWeatherForSavedLocations;

  WeatherForSavedLocationsBloc(this.getWeatherForSavedLocations)
      : assert(getWeatherForSavedLocations != null);

  @override
  WeatherForSavedLocationsState get initialState =>
      WeatherForSavedLocationsEmpty();

  @override
  Stream<WeatherForSavedLocationsState> mapEventToState(
    WeatherForSavedLocationsEvent event,
  ) async* {
    if (event is GetWeatherForSavedLocationsEvent) {
      yield WeatherForSavedLocationsLoading();

      final weatherEither = await getWeatherForSavedLocations(
        GetWeatherForSavedLocationsParams(event.locationPositions),
      );

      yield* weatherEither.fold((failure) async* {
        yield WeatherForSavedLocationsError(
            message: mapFailureToMessage(failure));
      }, (fullWeatherList) async* {
        yield WeatherForSavedLocationsLoaded(fullWeatherList: fullWeatherList);
      });
    }
  }
}
