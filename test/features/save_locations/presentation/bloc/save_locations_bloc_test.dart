import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:Weader/core/entities/entities.dart';
import 'package:Weader/core/error/failures.dart';
import 'package:Weader/core/usecases/usecase.dart';
import 'package:Weader/features/save_locations/domain/usecases/save_locations_usecases.dart';
import 'package:Weader/features/save_locations/presentation/bloc/bloc.dart';

class MockSaveLocation extends Mock implements SaveLocation {}

class MockGetSavedLocations extends Mock implements GetSavedLocations {}

class MockDeleteSavedLocation extends Mock implements DeleteSavedLocation {}

class MockDeleteAllSavedLocations extends Mock
    implements DeleteAllSavedLocations {}

void main() {
  SaveLocationsBloc saveLocationsBloc;
  MockSaveLocation mockSaveLocation;
  MockGetSavedLocations mockGetSavedLocations;
  MockDeleteSavedLocation mockDeleteSavedLocation;
  MockDeleteAllSavedLocations mockDeleteAllSavedLocations;

  SaveLocationsBloc returnBloc() => SaveLocationsBloc(
        saveLocation: mockSaveLocation,
        getSavedLocations: mockGetSavedLocations,
        deleteSavedLocation: mockDeleteSavedLocation,
        deleteAllSavedLocations: mockDeleteAllSavedLocations,
      );

  setUp(() {
    mockSaveLocation = MockSaveLocation();
    mockGetSavedLocations = MockGetSavedLocations();
    mockDeleteSavedLocation = MockDeleteSavedLocation();
    mockDeleteAllSavedLocations = MockDeleteAllSavedLocations();

    saveLocationsBloc = returnBloc();
  });

  test('initialState should be Empty', () {
    // assert
    expect(saveLocationsBloc.initialState, equals(SaveLocationsEmpty()));
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

  group('SaveLocation', () {
    final tLocation = Location(
      address: "",
      displayName: "",
      id: "",
      latitude: 1.0,
      longitude: 1.0,
    );
    blocTest(
      'should save data from the save location usecase',
      build: _buildWithBloc(
        () {
          when(mockSaveLocation(any))
              .thenAnswer((_) async => Right(tLocationsList));
        },
      ),
      act: (bloc) => bloc.add(SaveLocationEvent(tLocation)),
      verify: (_) async => verify(
        mockSaveLocation(
          SaveLocationParams(location: tLocation),
        ),
      ),
    );

    blocTest(
      'should emit [Loading, SaveLocationsLoaded] when data is gotten successfully',
      build: _buildWithBloc(
        () {
          when(mockSaveLocation(any))
              .thenAnswer((_) async => Right(tLocationsList));
        },
      ),
      act: (bloc) => bloc.add(SaveLocationEvent(tLocation)),
      expect: [
        SaveLocationsLoading(),
        SaveLocationsLoaded(
          locationsList: tLocationsList,
        ),
      ],
    );

    blocTest(
      'should emit [Loading, Error] when getting data fails with NoLocalDataFailure',
      build: _buildWithBloc(
        () {
          when(mockSaveLocation(any))
              .thenAnswer((_) async => Left(NoLocalDataFailure()));
        },
      ),
      act: (bloc) => bloc.add(SaveLocationEvent(tLocation)),
      expect: [
        SaveLocationsLoading(),
        SaveLocationsError(message: NO_LOCAL_DATA_FAILURE_MESSAGE),
      ],
    );
  });

  group('GetSavedLocationsListEvent', () {
    blocTest(
      'should get data from the get saved locations list usecase',
      build: _buildWithBloc(
        () {
          when(mockGetSavedLocations(any))
              .thenAnswer((_) async => Right(tLocationsList));
        },
      ),
      act: (bloc) => bloc.add(GetSavedLocationsEvent()),
      verify: (_) async => verify(
        mockGetSavedLocations(
          NoParams(),
        ),
      ),
    );

    blocTest(
      'should emit [Loading, SaveLocationsLoaded] when data is gotten successfully',
      build: _buildWithBloc(
        () {
          when(mockGetSavedLocations(any))
              .thenAnswer((_) async => Right(tLocationsList));
        },
      ),
      act: (bloc) => bloc.add(GetSavedLocationsEvent()),
      expect: [
        SaveLocationsLoading(),
        SaveLocationsLoaded(
          locationsList: tLocationsList,
        ),
      ],
    );

    blocTest(
      'should emit [Loading, Error] when getting data fails with NoLocalDataFailure',
      build: _buildWithBloc(
        () {
          when(mockGetSavedLocations(any))
              .thenAnswer((_) async => Left(NoLocalDataFailure()));
        },
      ),
      act: (bloc) => bloc.add(GetSavedLocationsEvent()),
      expect: [
        SaveLocationsLoading(),
        SaveLocationsError(message: NO_LOCAL_DATA_FAILURE_MESSAGE),
      ],
    );
  });

  group('DeleteSavedLocationEvent', () {
    final tId = "cdef4a60-a821-11ea-fbdc-4fc75fc69aa5";

    blocTest(
      'should get data from the delete saved location usecase',
      build: _buildWithBloc(
        () {
          when(mockDeleteSavedLocation(any))
              .thenAnswer((_) async => Right(tLocationsList));
        },
      ),
      act: (bloc) => bloc.add(
        DeleteSavedLocationEvent(
          id: tId,
        ),
      ),
      verify: (_) async => verify(
        mockDeleteSavedLocation(
          DeleteSavedLocationParams(id: tId),
        ),
      ),
    );

    blocTest(
      'should emit [Loading, SaveLocationsLoaded] when data is gotten successfully',
      build: _buildWithBloc(
        () {
          when(mockDeleteSavedLocation(any))
              .thenAnswer((_) async => Right(tLocationsList));
        },
      ),
      act: (bloc) => bloc.add(
        DeleteSavedLocationEvent(
          id: tId,
        ),
      ),
      expect: [
        SaveLocationsLoading(),
        SaveLocationsLoaded(
          locationsList: tLocationsList,
        ),
      ],
    );

    blocTest(
      'should emit [Loading, Error] when getting data fails with UnexpectedFailure',
      build: _buildWithBloc(
        () {
          when(mockDeleteSavedLocation(any))
              .thenAnswer((_) async => Left(UnexpectedFailure()));
        },
      ),
      act: (bloc) => bloc.add(
        DeleteSavedLocationEvent(
          id: tId,
        ),
      ),
      expect: [
        SaveLocationsLoading(),
        SaveLocationsError(message: UNEXPECTED_FAILURE_MESSAGE),
      ],
    );
  });

  group('DeleteAllSavedLocationsEvent', () {
    blocTest(
      'should get data from the delete all saved locations usecase',
      build: _buildWithBloc(
        () {
          when(mockDeleteAllSavedLocations(any))
              .thenAnswer((_) async => Right(tLocationsList));
        },
      ),
      act: (bloc) => bloc.add(
        DeleteAllSavedLocationsEvent(),
      ),
      verify: (_) async => verify(
        mockDeleteAllSavedLocations(NoParams()),
      ),
    );

    blocTest(
      'should emit [Loading, SaveLocationsLoaded] when data is removed successfully',
      build: _buildWithBloc(
        () {
          when(mockDeleteAllSavedLocations(any))
              .thenAnswer((_) async => Right(tLocationsList));
        },
      ),
      act: (bloc) => bloc.add(DeleteAllSavedLocationsEvent()),
      expect: [
        SaveLocationsLoading(),
        SaveLocationsLoaded(
          locationsList: tLocationsList,
        ),
      ],
    );

    blocTest(
      'should emit [Loading, Error] when removing data fails with UnexpectedException',
      build: _buildWithBloc(
        () {
          when(mockDeleteAllSavedLocations(any))
              .thenAnswer((_) async => Left(UnexpectedFailure()));
        },
      ),
      act: (bloc) => bloc.add(
        DeleteAllSavedLocationsEvent(),
      ),
      expect: [
        SaveLocationsLoading(),
        SaveLocationsError(message: UNEXPECTED_FAILURE_MESSAGE),
      ],
    );
  });
}
