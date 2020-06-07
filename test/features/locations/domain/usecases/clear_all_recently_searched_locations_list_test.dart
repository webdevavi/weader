import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weader/core/usecases/usecase.dart';
import 'package:weader/features/locations/domain/repository/locations_repository.dart';
import 'package:weader/features/locations/domain/usecases/clear_all_recently_searched_locations_list.dart';

class MockLocationsRepository extends Mock implements LocationsRepository {}

void main() {
  ClearAllRecentlySearchedLocationsList usecase;
  MockLocationsRepository mockLocationsRepository;

  setUp(() {
    mockLocationsRepository = MockLocationsRepository();
    usecase = ClearAllRecentlySearchedLocationsList(mockLocationsRepository);
  });

  test(
    'should return true after removing all recently searched locations list',
    () async {
      // arrange
      when(mockLocationsRepository.clearAllRecentlySearchedLocation())
          .thenAnswer((_) async => Right(true));
      // act
      final result = await usecase(NoParams());
      // assert
      expect(result, equals(Right(true)));
      verify(mockLocationsRepository.clearAllRecentlySearchedLocation());
      verifyNoMoreInteractions(mockLocationsRepository);
    },
  );
}
