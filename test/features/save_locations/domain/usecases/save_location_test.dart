import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:Weader/core/entities/entities.dart';
import 'package:Weader/features/save_locations/domain/repository/save_locations_repository.dart';
import 'package:Weader/features/save_locations/domain/usecases/save_locations_usecases.dart';

class MockSaveLocationsRepository extends Mock
    implements SaveLocationsRepository {}

void main() {
  SaveLocation usecase;
  MockSaveLocationsRepository mockSaveLocationsRepository;

  setUp(() {
    mockSaveLocationsRepository = MockSaveLocationsRepository();

    usecase = SaveLocation(mockSaveLocationsRepository);
  });

  final tLocation = Location(
    id: "cdef4a60-a821-11ea-fbdc-4fc75fc69aa5",
    address: 'Karnataka, India',
    displayName: 'Bengaluru',
    latitude: 1.0,
    longitude: 1.0,
  );

  final tLocationsList = LocationsList(
    locationsList: [tLocation],
  );

  test(
    'should return locations list from the repository',
    () async {
      // arrange
      when(mockSaveLocationsRepository.saveLocation(any)).thenAnswer(
        (_) async => Right(tLocationsList),
      );
      // act
      final result = await usecase(
        SaveLocationParams(
          location: tLocation,
        ),
      );
      // assert
      verify(
        mockSaveLocationsRepository.saveLocation(
          tLocation,
        ),
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
