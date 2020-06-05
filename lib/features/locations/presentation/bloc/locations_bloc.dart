import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:weader/core/error/failures.dart';
import 'package:weader/features/locations/domain/entities/locations_list.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/util/input_checker.dart';

import './bloc.dart';
import '../../domain/usecases/get_device_locations_list.dart';
import '../../domain/usecases/get_locations_list.dart';

class LocationsBloc extends Bloc<LocationsEvent, LocationsState> {
  final GetLocationsList getLocationsList;
  final GetDeviceLocationsList getDeviceLocationsList;
  final InputChecker inputChecker;

  LocationsBloc({
    @required this.getLocationsList,
    @required this.getDeviceLocationsList,
    @required this.inputChecker,
  })  : assert(getLocationsList != null),
        assert(getDeviceLocationsList != null),
        assert(inputChecker != null);

  @override
  LocationsState get initialState => LocationsEmpty();

  @override
  Stream<LocationsState> mapEventToState(
    LocationsEvent event,
  ) async* {
    if (event is GetLocationsListEvent) {
      final inputEither = inputChecker.checkNull(event.queryString);

      yield* inputEither.fold(
        (failure) async* {
          yield LocationsError(message: INVALID_INPUT_FAILURE_MESSAGE);
        },
        (string) async* {
          yield LocationsLoading();
          final locationsListEither =
              await getLocationsList(Params(queryString: string));

          yield* _eitherLoadedOrErrorState(locationsListEither);
        },
      );
    } else if (event is GetDeviceLocationsListEvent) {
      yield LocationsLoading();
      final deviceLocationsListEither =
          await getDeviceLocationsList(NoParams());

      yield* _eitherLoadedOrErrorState(deviceLocationsListEither);
    }
  }

  Stream<LocationsState> _eitherLoadedOrErrorState(
    Either<Failure, LocationsList> either,
  ) async* {
    yield either.fold(
      (failure) => LocationsError(message: mapFailureToMessage(failure)),
      (locationsList) => LocationsLoaded(locationsList: locationsList),
    );
  }
}
