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
  DeleteAllSavedLocations usecase;
  MockSaveLocationsRepository mockSaveLocationsRepository;

  setUp(() {
    mockSaveLocationsRepository = MockSaveLocationsRepository();

    usecase = DeleteAllSavedLocations(mockSaveLocationsRepository);
  });

  final tLocationsList = LocationsList(
    locationsList: [],
  );

  test(
    'should return empty locations list from repository',
    () async {
      // arrange
      when(mockSaveLocationsRepository.deleteAllSavedLocations()).thenAnswer(
        (_) async => Right(tLocationsList),
      );
      // act
      final result = await usecase(NoParams());
      // assert
      verify(
        mockSaveLocationsRepository.deleteAllSavedLocations(),
      );
      expect(
        result,
        equals(
          Right(
            tLocationsList,
          ),
        ),
      );
      verifyNoMoreInteractions(mockSaveLocationsRepository);
    },
  );
}
