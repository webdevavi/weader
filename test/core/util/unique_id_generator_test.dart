import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:uuid/uuid.dart';
import 'package:weader/core/util/unique_id_generator.dart';

class MockUuid extends Mock implements Uuid {}

void main() {
  MockUuid mockUuid;
  UniqueIdGenerator uniqueIdGenerator;

  setUp(() {
    mockUuid = MockUuid();
    uniqueIdGenerator = UniqueIdGenerator(mockUuid);
  });

  test(
    'should return a string of unique characters',
    () async {
      // arrange
      when(mockUuid.v1()).thenAnswer((_) => "abc");
      // act
      final result = uniqueIdGenerator.getId;
      // assert
      expect(result, "abc");
    },
  );
}
