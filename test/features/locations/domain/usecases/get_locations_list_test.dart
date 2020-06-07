import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weader/core/entities/entities.dart';
import 'package:weader/features/locations/domain/entities/locations_list.dart';
import 'package:weader/features/locations/domain/repository/locations_repository.dart';
import 'package:weader/features/locations/domain/usecases/get_locations_list.dart';

class MockLocationsRepository extends Mock implements LocationsRepository {}

void main() {
  GetLocationsList usecase;
  MockLocationsRepository mockLocationsRepository;

  setUp(() {
    mockLocationsRepository = MockLocationsRepository();
    usecase = GetLocationsList(mockLocationsRepository);
  });

  final tQueryString = 'bengaluru';
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
    'should get locations list from repository for the query string',
    () async {
      // arrange
      when(mockLocationsRepository.getLocationsList(any))
          .thenAnswer((_) async => Right(tLocationsList));
      // act
      final result = await usecase(Params(queryString: tQueryString));
      // assert
      expect(result, equals(Right(tLocationsList)));
      verify(mockLocationsRepository.getLocationsList(tQueryString));
      verifyNoMoreInteractions(mockLocationsRepository);
    },
  );
}
