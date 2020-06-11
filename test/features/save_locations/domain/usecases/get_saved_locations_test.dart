import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:Weader/core/entities/entities.dart';
import 'package:Weader/core/usecases/usecase.dart';
import 'package:Weader/features/save_locations/domain/repository/save_locations_repository.dart';
import 'package:Weader/features/save_locations/domain/usecases/save_locations_usecases.dart';

class MockSaveLocationsRepository extends Mock
    implements SaveLocationsRepository {}

void main() {
  GetSavedLocations usecase;
  MockSaveLocationsRepository mockSaveLocationsRepository;

  setUp(() {
    mockSaveLocationsRepository = MockSaveLocationsRepository();

    usecase = GetSavedLocations(mockSaveLocationsRepository);
  });

  final tLocationsList = LocationsList(
    locationsList: [
      Location(
        id: "cdef4a60-a821-11ea-fbdc-4fc75fc69aa5",
        address: 'Karnataka, India',
        displayName: 'Bengaluru',
        latitude: 1.0,
        longitude: 1.0,
      )
    ],
  );

  test(
    'should return locations list from the repository',
    () async {
      // arrange
      when(mockSaveLocationsRepository.getSavedLocationsList()).thenAnswer(
        (_) async => Right(tLocationsList),
      );
      // act
      final result = await usecase(NoParams());
      // assert
      verify(
        mockSaveLocationsRepository.getSavedLocationsList(),
      );
      expect(
        result,
        equals(
          Right(tLocationsList),
        ),
      );
      verifyNoMoreInteractions(mockSaveLocationsRepository);
    },
  );
}
