import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weader/core/entities/entities.dart';
import 'package:weader/core/usecases/usecase.dart';
import 'package:weader/features/locations/domain/entities/locations_list.dart';
import 'package:weader/features/locations/domain/repository/locations_repository.dart';
import 'package:weader/features/locations/domain/usecases/get_recently_searched_locations_list.dart';

class MockLocationsRepository extends Mock implements LocationsRepository {}

void main() {
  GetRecentlySearchedLocationsList usecase;
  MockLocationsRepository mockLocationsRepository;

  setUp(() {
    mockLocationsRepository = MockLocationsRepository();
    usecase = GetRecentlySearchedLocationsList(mockLocationsRepository);
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
      when(mockLocationsRepository.getRecentlySearchedLocationsList())
          .thenAnswer((_) async => Right(tLocationsList));
      // act
      final result = await usecase(NoParams());
      // assert
      expect(result, equals(Right(tLocationsList)));
      verify(mockLocationsRepository.getRecentlySearchedLocationsList());
      verifyNoMoreInteractions(mockLocationsRepository);
    },
  );
}
