import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weader/core/entities/entities.dart';
import 'package:weader/core/error/failures.dart';
import 'package:weader/core/usecases/usecase.dart';
import 'package:weader/core/util/input_checker.dart';
import 'package:weader/features/locations/domain/entities/locations_list.dart';
import 'package:weader/features/locations/domain/usecases/get_device_locations_list.dart';
import 'package:weader/features/locations/domain/usecases/get_locations_list.dart';
import 'package:weader/features/locations/presentation/bloc/bloc.dart';

class MockGetLocationsList extends Mock implements GetLocationsList {}

class MockGetDeviceLocationsList extends Mock
    implements GetDeviceLocationsList {}

class MockInputChecker extends Mock implements InputChecker {}

void main() {
  LocationsBloc locationsBloc;
  MockGetLocationsList mockGetLocationsList;
  MockGetDeviceLocationsList mockGetDeviceLocationsList;
  MockInputChecker mockInputChecker;

  setUp(() {
    mockGetLocationsList = MockGetLocationsList();
    mockGetDeviceLocationsList = MockGetDeviceLocationsList();
    mockInputChecker = MockInputChecker();

    locationsBloc = LocationsBloc(
      getLocationsList: mockGetLocationsList,
      getDeviceLocationsList: mockGetDeviceLocationsList,
      inputChecker: mockInputChecker,
    );
  });

  test('initialState should be Empty', () {
    // assert
    expect(locationsBloc.initialState, equals(LocationsEmpty()));
  });

  final String tQueryString = 'bengaluru';
  final tLocationsList = LocationsList(
    locationsList: [
      Location(
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
      return LocationsBloc(
        getLocationsList: mockGetLocationsList,
        getDeviceLocationsList: mockGetDeviceLocationsList,
        inputChecker: mockInputChecker,
      );
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
        LocationsError(message: INVALID_INPUT_FAILURE_MESSAGE),
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
        LocationsLoading(),
        LocationsLoaded(locationsList: tLocationsList),
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
        LocationsLoading(),
        LocationsError(message: NOT_FOUND_FAILURE_MESSAGE),
      ],
    );
  });

  group('getDeviceLocationsList', () {
    blocTest(
      'should get data from the get device locations list usecase',
      build: _buildWithBloc(
        () {
          when(mockGetDeviceLocationsList(any))
              .thenAnswer((_) async => Right(tLocationsList));
        },
      ),
      act: (bloc) => bloc.add(GetDeviceLocationsListEvent()),
      verify: (_) async => verify(mockGetDeviceLocationsList(NoParams())),
    );

    blocTest(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: _buildWithBloc(
        () {
          when(mockGetDeviceLocationsList(any))
              .thenAnswer((_) async => Right(tLocationsList));
        },
      ),
      act: (bloc) => bloc.add(GetDeviceLocationsListEvent()),
      expect: [
        LocationsLoading(),
        LocationsLoaded(locationsList: tLocationsList),
      ],
    );

    blocTest(
      'should emit [Loading, Error] when getting data fails with DeviceLocationFailure',
      build: _buildWithBloc(
        () {
          when(mockGetDeviceLocationsList(any))
              .thenAnswer((_) async => Left(DeviceLocationFailure()));
        },
      ),
      act: (bloc) => bloc.add(GetDeviceLocationsListEvent()),
      expect: [
        LocationsLoading(),
        LocationsError(message: DEVICE_LOCATION_FAILURE_MESSAGE),
      ],
    );

    blocTest(
      'should emit [Loading, Error] when getting data fails with NotFoundFailure',
      build: _buildWithBloc(
        () {
          when(mockGetDeviceLocationsList(any))
              .thenAnswer((_) async => Left(NotFoundFailure()));
        },
      ),
      act: (bloc) => bloc.add(GetDeviceLocationsListEvent()),
      expect: [
        LocationsLoading(),
        LocationsError(message: NOT_FOUND_FAILURE_MESSAGE),
      ],
    );
  });
}
