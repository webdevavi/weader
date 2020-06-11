import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:Weader/core/entities/entities.dart';
import 'package:Weader/core/error/failures.dart';
import 'package:Weader/core/usecases/usecase.dart';
import 'package:Weader/core/util/input_checker.dart';
import 'package:Weader/features/search_locations/domain/usecases/search_locations_usecases.dart';
import 'package:Weader/features/search_locations/presentation/bloc/bloc.dart';

class MockGetLocationsList extends Mock implements GetLocationsList {}

class MockGetRecentlySearchedLocationsList extends Mock
    implements GetRecentlySearchedLocationsList {}

class MockClearOneRecentlySearchedLocation extends Mock
    implements ClearOneRecentlySearchedLocation {}

class MockClearAllRecentlySearchedLocationsList extends Mock
    implements ClearAllRecentlySearchedLocationsList {}

class MockInputChecker extends Mock implements InputChecker {}

void main() {
  SearchLocationsBloc searchLocationsBloc;
  MockGetLocationsList mockGetLocationsList;
  MockGetRecentlySearchedLocationsList mockGetRecentlySearchedLocationsList;
  MockClearOneRecentlySearchedLocation mockClearOneRecentlySearchedLocation;
  MockClearAllRecentlySearchedLocationsList
      mockClearAllRecentlySearchedLocationsList;

  MockInputChecker mockInputChecker;

  SearchLocationsBloc returnBloc() => SearchLocationsBloc(
        getLocationsList: mockGetLocationsList,
        getRecentlySearchedLocationsList: mockGetRecentlySearchedLocationsList,
        clearOneRecentlySearchedLocation: mockClearOneRecentlySearchedLocation,
        clearAllRecentlySearchedLocationsList:
            mockClearAllRecentlySearchedLocationsList,
        inputChecker: mockInputChecker,
      );

  setUp(() {
    mockGetLocationsList = MockGetLocationsList();

    mockGetRecentlySearchedLocationsList =
        MockGetRecentlySearchedLocationsList();
    mockClearOneRecentlySearchedLocation =
        MockClearOneRecentlySearchedLocation();
    mockClearAllRecentlySearchedLocationsList =
        MockClearAllRecentlySearchedLocationsList();

    mockInputChecker = MockInputChecker();

    searchLocationsBloc = returnBloc();
  });

  test('initialState should be Empty', () {
    // assert
    expect(searchLocationsBloc.initialState, equals(SearchLocationsEmpty()));
  });

  final String tQueryString = 'bengaluru';
  final tLocationsList = LocationsList(
    locationsList: [
      Location(
        id: "cdef4a60-a821-11ea-fbdc-4fc75fc69aa5",
        address: 'Bengaluru, Bengaluru Urban, Karnataka, India',
        displayName: 'Bengaluru',
        latitude: 12.9715987,
        longitude: 77.5945627,
      ),
    ],
  );

  _buildWithBloc(Function body) {
    return () async {
      body();
      return returnBloc();
    };
  }

  group('getLocationsList', () {
    void setUpMockInputCheckerSuccess() =>
        when(mockInputChecker.checkNull(any)).thenReturn(Right(tQueryString));
    void setUpMockInputCheckerFailure() => when(mockInputChecker.checkNull(any))
        .thenReturn(Left(InvalidInputFailure()));

    blocTest(
      'should call input checker to check if the input string is null or empty',
      build: _buildWithBloc(
        () => setUpMockInputCheckerSuccess(),
      ),
      act: (bloc) => bloc.add(GetLocationsListEvent(tQueryString)),
      verify: (_) async => verify(mockInputChecker.checkNull(tQueryString)),
    );

    blocTest(
      'should emit [Error] when the input is invalid',
      build: _buildWithBloc(
        () => setUpMockInputCheckerFailure(),
      ),
      act: (bloc) => bloc.add(GetLocationsListEvent(tQueryString)),
      expect: [
        SearchLocationsError(message: INVALID_INPUT_FAILURE_MESSAGE),
      ],
    );

    blocTest(
      'should get data from the get locations list usecase',
      build: _buildWithBloc(
        () {
          setUpMockInputCheckerSuccess();
          when(mockGetLocationsList(any))
              .thenAnswer((_) async => Right(tLocationsList));
        },
      ),
      act: (bloc) => bloc.add(GetLocationsListEvent(tQueryString)),
      verify: (_) async =>
          verify(mockGetLocationsList(Params(queryString: tQueryString))),
    );

    blocTest(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: _buildWithBloc(
        () {
          setUpMockInputCheckerSuccess();
          when(mockGetLocationsList(any))
              .thenAnswer((_) async => Right(tLocationsList));
        },
      ),
      act: (bloc) => bloc.add(GetLocationsListEvent(tQueryString)),
      expect: [
        SearchLocationsLoading(),
        SearchLocationsLoaded(locationsList: tLocationsList),
      ],
    );

    blocTest(
      'should emit [Loading, Error] when getting data fails',
      build: _buildWithBloc(
        () {
          setUpMockInputCheckerSuccess();
          when(mockGetLocationsList(any))
              .thenAnswer((_) async => Left(NotFoundFailure()));
        },
      ),
      act: (bloc) => bloc.add(GetLocationsListEvent(tQueryString)),
      expect: [
        SearchLocationsLoading(),
        SearchLocationsError(message: NOT_FOUND_FAILURE_MESSAGE),
      ],
    );
  });

  group('GetRecentlySearchedLocationsListEvent', () {
    blocTest(
      'should get data from the get recently searched locations list usecase',
      build: _buildWithBloc(
        () {
          when(mockGetRecentlySearchedLocationsList(any))
              .thenAnswer((_) async => Right(tLocationsList));
        },
      ),
      act: (bloc) => bloc.add(GetRecentlySearchedLocationsListEvent()),
      verify: (_) async => verify(
        mockGetRecentlySearchedLocationsList(
          NoParams(),
        ),
      ),
    );

    blocTest(
      'should emit [Loading, RecentlySearchedLocationsLoaded] when data is gotten successfully',
      build: _buildWithBloc(
        () {
          when(mockGetRecentlySearchedLocationsList(any))
              .thenAnswer((_) async => Right(tLocationsList));
        },
      ),
      act: (bloc) => bloc.add(GetRecentlySearchedLocationsListEvent()),
      expect: [
        SearchLocationsLoading(),
        RecentlySearchedLocationsLoaded(
          recentlySearchedLocationsList: tLocationsList,
        ),
      ],
    );

    blocTest(
      'should emit [Loading, Error] when getting data fails with NoLocalDataFailure',
      build: _buildWithBloc(
        () {
          when(mockGetRecentlySearchedLocationsList(any))
              .thenAnswer((_) async => Left(NoLocalDataFailure()));
        },
      ),
      act: (bloc) => bloc.add(GetRecentlySearchedLocationsListEvent()),
      expect: [
        SearchLocationsLoading(),
        SearchLocationsError(message: NO_LOCAL_DATA_FAILURE_MESSAGE),
      ],
    );
  });

  group('ClearOneRecentlySearchedLocation', () {
    final tId = "cdef4a60-a821-11ea-fbdc-4fc75fc69aa5";

    blocTest(
      'should get data from the clear one recently searched location usecase',
      build: _buildWithBloc(
        () {
          when(mockClearOneRecentlySearchedLocation(any))
              .thenAnswer((_) async => Right(tLocationsList));
        },
      ),
      act: (bloc) => bloc.add(
        ClearOneRecentlySearchedLocationEvent(
          id: tId,
        ),
      ),
      verify: (_) async => verify(
        mockClearOneRecentlySearchedLocation(
          IDParams(id: tId),
        ),
      ),
    );

    blocTest(
      'should emit [Loading, RecentlySearchedLocationsLoaded] when data is gotten successfully',
      build: _buildWithBloc(
        () {
          when(mockClearOneRecentlySearchedLocation(any))
              .thenAnswer((_) async => Right(tLocationsList));
        },
      ),
      act: (bloc) => bloc.add(
        ClearOneRecentlySearchedLocationEvent(
          id: tId,
        ),
      ),
      expect: [
        SearchLocationsLoading(),
        RecentlySearchedLocationsLoaded(
          recentlySearchedLocationsList: tLocationsList,
        ),
      ],
    );

    blocTest(
      'should emit [Loading, Error] when getting data fails with DeviceLocationFailure',
      build: _buildWithBloc(
        () {
          when(mockClearOneRecentlySearchedLocation(any))
              .thenAnswer((_) async => Left(UnexpectedFailure()));
        },
      ),
      act: (bloc) => bloc.add(
        ClearOneRecentlySearchedLocationEvent(
          id: tId,
        ),
      ),
      expect: [
        SearchLocationsLoading(),
        SearchLocationsError(message: UNEXPECTED_FAILURE_MESSAGE),
      ],
    );
  });

  group('ClearAllRecentlySearchedLocationsList', () {
    blocTest(
      'should get data from the clear all recently searched locations list usecase',
      build: _buildWithBloc(
        () {
          when(mockClearAllRecentlySearchedLocationsList(any))
              .thenAnswer((_) async => Right(tLocationsList));
        },
      ),
      act: (bloc) => bloc.add(
        ClearAllRecentlySearchedLocationsListEvent(),
      ),
      verify: (_) async => verify(
        mockClearAllRecentlySearchedLocationsList(NoParams()),
      ),
    );

    blocTest(
      'should emit [Loading, RecentlySearchedLocationsLoaded] when data is removed successfully',
      build: _buildWithBloc(
        () {
          when(mockClearAllRecentlySearchedLocationsList(any))
              .thenAnswer((_) async => Right(tLocationsList));
        },
      ),
      act: (bloc) => bloc.add(ClearAllRecentlySearchedLocationsListEvent()),
      expect: [
        SearchLocationsLoading(),
        RecentlySearchedLocationsLoaded(
          recentlySearchedLocationsList: tLocationsList,
        ),
      ],
    );

    blocTest(
      'should emit [Loading, Error] when removing data fails with UnexpectedException',
      build: _buildWithBloc(
        () {
          when(mockClearAllRecentlySearchedLocationsList(any))
              .thenAnswer((_) async => Left(UnexpectedFailure()));
        },
      ),
      act: (bloc) => bloc.add(
        ClearAllRecentlySearchedLocationsListEvent(),
      ),
      expect: [
        SearchLocationsLoading(),
        SearchLocationsError(message: UNEXPECTED_FAILURE_MESSAGE),
      ],
    );
  });
}
