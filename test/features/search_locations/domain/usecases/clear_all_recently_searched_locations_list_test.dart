import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:Weader/core/entities/entities.dart';
import 'package:Weader/core/entities/location.dart';
import 'package:Weader/core/usecases/usecase.dart';
import 'package:Weader/features/search_locations/domain/repository/search_locations_repository.dart';
import 'package:Weader/features/search_locations/domain/usecases/search_locations_usecases.dart';

class MockSearchLocationsRepository extends Mock
    implements SearchLocationsRepository {}

void main() {
  ClearAllRecentlySearchedLocationsList usecase;
  MockSearchLocationsRepository mockSearchLocationsRepository;

  setUp(() {
    mockSearchLocationsRepository = MockSearchLocationsRepository();
    usecase =
        ClearAllRecentlySearchedLocationsList(mockSearchLocationsRepository);
  });

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

  test(
    'should return empty LocationsList after removing all recently searched locations list',
    () async {
      // arrange
      when(mockSearchLocationsRepository.clearAllRecentlySearchedLocation())
          .thenAnswer((_) async => Right(tLocationsList));
      // act
      final result = await usecase(NoParams());
      // assert
      expect(result, equals(Right(tLocationsList)));
      verify(mockSearchLocationsRepository.clearAllRecentlySearchedLocation());
      verifyNoMoreInteractions(mockSearchLocationsRepository);
    },
  );
}
