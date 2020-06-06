import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weader/core/entities/settings.dart';
import 'package:weader/core/usecases/usecase.dart';
import 'package:weader/features/settings/domain/repository/settings_repository.dart';
import 'package:weader/features/settings/domain/usecases/get_settings.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  GetSettings usecase;
  MockSettingsRepository mockSettingsRepository;

  setUp(() {
    mockSettingsRepository = MockSettingsRepository();
    usecase = GetSettings(mockSettingsRepository);
  });

  final tSettings = Settings(
    unitSystem: UnitSystem(
      isImperial: false,
    ),
    timeFormat: TimeFormat(
      is24Hours: false,
    ),
    dataPreference: DataPreference(
      isLocal: true,
    ),
    currentTheme: CurrentTheme(
      isDark: false,
    ),
    wallpaper: Wallpaper(
      isTimeAware: true,
    ),
  );

  test(
    'should get settings from the repository',
    () async {
      // arrange
      when(mockSettingsRepository.getSettings())
          .thenAnswer((_) async => Right(tSettings));
      // act
      final result = await usecase(NoParams());
      // assert
      expect(result, Right(tSettings));
      verify(mockSettingsRepository.getSettings());
      verifyNoMoreInteractions(mockSettingsRepository);
    },
  );
}
