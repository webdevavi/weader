import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:Weader/core/entities/entities.dart';
import 'package:Weader/core/usecases/usecase.dart';
import 'package:Weader/features/search_locations/domain/repository/search_locations_repository.dart';
import 'package:Weader/features/search_locations/domain/usecases/search_locations_usecases.dart';

class MockSearchLocationsRepository extends Mock
    implements SearchLocationsRepository {}

void main() {
  GetRecentlySearchedLocationsList usecase;
  MockSearchLocationsRepository mockSearchLocationsRepository;

  setUp(() {
    mockSearchLocationsRepository = MockSearchLocationsRepository();
    usecase = GetRecentlySearchedLocationsList(mockSearchLocationsRepository);
  });

  final tLocationsList = LocationsList(
    locationsList: [
      Location(
        id: "cdef4a60-a821-11ea-fbdc-4fc75fc69aa5",
        address: 'Karnataka, India',
        displayName: 'Bengaluru',
        latitude: 1.0,
        longitude: 1.0,
      ),
    ],
  );

  test(
    'should get recently searched locations list from repository',
    () async {
      // arrange
      when(mockSearchLocationsRepository.getRecentlySearchedLocationsList())
          .thenAnswer((_) async => Right(tLocationsList));
      // act
      final result = await usecase(NoParams());
      // assert
      expect(result, equals(Right(tLocationsList)));
      verify(mockSearchLocationsRepository.getRecentlySearchedLocationsList());
      verifyNoMoreInteractions(mockSearchLocationsRepository);
    },
  );
}
