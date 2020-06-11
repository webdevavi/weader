import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import './bloc.dart';
import '../../../../core/entities/entities.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/util/input_checker.dart';
import '../../domain/usecases/get_locations_list.dart';
import '../../domain/usecases/search_locations_usecases.dart';

class SearchLocationsBloc
    extends Bloc<SearchLocationsEvent, SearchLocationsState> {
  final GetLocationsList getLocationsList;
  final GetRecentlySearchedLocationsList getRecentlySearchedLocationsList;
  final ClearOneRecentlySearchedLocation clearOneRecentlySearchedLocation;
  final ClearAllRecentlySearchedLocationsList
      clearAllRecentlySearchedLocationsList;

  final InputChecker inputChecker;

  SearchLocationsBloc({
    @required this.getLocationsList,
    @required this.getRecentlySearchedLocationsList,
    @required this.clearOneRecentlySearchedLocation,
    @required this.clearAllRecentlySearchedLocationsList,
    @required this.inputChecker,
  })  : assert(getLocationsList != null),
        assert(getRecentlySearchedLocationsList != null),
        assert(clearOneRecentlySearchedLocation != null),
        assert(clearAllRecentlySearchedLocationsList != null),
        assert(inputChecker != null);

  @override
  SearchLocationsState get initialState => SearchLocationsEmpty();

  @override
  Stream<SearchLocationsState> mapEventToState(
    SearchLocationsEvent event,
  ) async* {
    if (event is GetLocationsListEvent) {
      final inputEither = inputChecker.checkNull(event.queryString);

      yield* inputEither.fold(
        (failure) async* {
          yield SearchLocationsError(message: INVALID_INPUT_FAILURE_MESSAGE);
        },
        (string) async* {
          yield SearchLocationsLoading();
          final locationsListEither =
              await getLocationsList(Params(queryString: string));
          yield locationsListEither.fold(
            (failure) =>
                SearchLocationsError(message: mapFailureToMessage(failure)),
            (locationsList) =>
                SearchLocationsLoaded(locationsList: locationsList),
          );
        },
      );
    } else if (event is GetRecentlySearchedLocationsListEvent) {
      yield SearchLocationsLoading();
      final recentlySearchedLocationsListEither =
          await getRecentlySearchedLocationsList(
        NoParams(),
      );
      yield* _eitherRecentlySearchLoadedOrErrorState(
        recentlySearchedLocationsListEither,
      );
    } else if (event is ClearOneRecentlySearchedLocationEvent) {
      yield SearchLocationsLoading();
      final recentlySearchedLocationsListEither =
          await clearOneRecentlySearchedLocation(
        IDParams(
          id: event.id,
        ),
      );
      yield* _eitherRecentlySearchLoadedOrErrorState(
        recentlySearchedLocationsListEither,
      );
    } else if (event is ClearAllRecentlySearchedLocationsListEvent) {
      yield SearchLocationsLoading();
      final locationsRecentlySearchedClearedEither =
          await clearAllRecentlySearchedLocationsList(
        NoParams(),
      );

      yield* _eitherRecentlySearchLoadedOrErrorState(
        locationsRecentlySearchedClearedEither,
      );
    }
  }

  Stream<SearchLocationsState> _eitherRecentlySearchLoadedOrErrorState(
    Either<Failure, LocationsList> either,
  ) async* {
    yield either.fold(
      (failure) => SearchLocationsError(message: mapFailureToMessage(failure)),
      (recentlySearchedLocationsList) => RecentlySearchedLocationsLoaded(
          recentlySearchedLocationsList: recentlySearchedLocationsList),
    );
  }
}
