import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import './bloc.dart';
import '../../../../core/entities/entities.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/save_locations_usecases.dart';

class SaveLocationsBloc extends Bloc<SaveLocationsEvent, SaveLocationsState> {
  final SaveLocation saveLocation;
  final GetSavedLocations getSavedLocations;
  final DeleteSavedLocation deleteSavedLocation;
  final DeleteAllSavedLocations deleteAllSavedLocations;

  SaveLocationsBloc({
    @required this.saveLocation,
    @required this.getSavedLocations,
    @required this.deleteSavedLocation,
    @required this.deleteAllSavedLocations,
  })  : assert(saveLocation != null),
        assert(getSavedLocations != null),
        assert(deleteSavedLocation != null),
        assert(deleteAllSavedLocations != null);

  @override
  SaveLocationsState get initialState => SaveLocationsEmpty();

  @override
  Stream<SaveLocationsState> mapEventToState(
    SaveLocationsEvent event,
  ) async* {
    if (event is SaveLocationEvent) {
      yield SaveLocationsLoading();
      final saveLocationeither =
          await saveLocation(SaveLocationParams(location: event.location));

      yield* _eitherSavedLocationsLoadedOrErrorState(
        saveLocationeither,
      );
    } else if (event is GetSavedLocationsEvent) {
      yield SaveLocationsLoading();
      final savedLocationsEither = await getSavedLocations(NoParams());

      yield* _eitherSavedLocationsLoadedOrErrorState(
        savedLocationsEither,
      );
    } else if (event is DeleteSavedLocationEvent) {
      yield SaveLocationsLoading();
      final savedLocationDeletedEither =
          await deleteSavedLocation(DeleteSavedLocationParams(id: event.id));

      yield* _eitherSavedLocationsLoadedOrErrorState(
        savedLocationDeletedEither,
      );
    } else if (event is DeleteAllSavedLocationsEvent) {
      yield SaveLocationsLoading();
      final savedLocationsDeletedEither =
          await deleteAllSavedLocations(NoParams());

      yield* _eitherSavedLocationsLoadedOrErrorState(
        savedLocationsDeletedEither,
      );
    }
  }

  Stream<SaveLocationsState> _eitherSavedLocationsLoadedOrErrorState(
    Either<Failure, LocationsList> either,
  ) async* {
    yield either.fold(
      (failure) => SaveLocationsError(message: mapFailureToMessage(failure)),
      (locationsList) => SaveLocationsLoaded(locationsList: locationsList),
    );
  }
}
