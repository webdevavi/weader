import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weader/core/usecases/usecase.dart';
import 'package:weader/features/locations/domain/entities/locations_list.dart';
import 'package:weader/features/locations/domain/repository/locations_repository.dart';
import 'package:weader/features/locations/domain/usecases/get_device_locations_list.dart';

class MockLocationsRepository extends Mock implements LocationsRepository {}

void main() {
  GetDeviceLocationsList usecase;
  MockLocationsRepository mockLocationsRepository;

  setUp(() {
    mockLocationsRepository = MockLocationsRepository();
    usecase = GetDeviceLocationsList(mockLocationsRepository);
  });

  final tLocationsList = LocationsList(
    locationsList: [
      Location(
        address: 'Karnataka, India',
        displayName: 'Bengaluru',
        latitude: 1.0,
        longitude: 1.0,
      ),
    ],
  );

  test(
    'should get device locations list from repository',
    () async {
      // arrange
      when(mockLocationsRepository.getDeviceLocationsList())
          .thenAnswer((_) async => Right(tLocationsList));
      // act
      final result = await usecase(NoParams());
      // assert
      expect(result, equals(Right(tLocationsList)));
      verify(mockLocationsRepository.getDeviceLocationsList());
      verifyNoMoreInteractions(mockLocationsRepository);
    },
  );
}
