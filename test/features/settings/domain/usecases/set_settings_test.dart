import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weader/core/entities/settings.dart';
import 'package:weader/features/settings/data/models/settings_model.dart';
import 'package:weader/features/settings/domain/repository/settings_repository.dart';
import 'package:weader/features/settings/domain/usecases/set_settings.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  SetSettings usecase;
  MockSettingsRepository mockSettingsRepository;

  setUp(() {
    mockSettingsRepository = MockSettingsRepository();
    usecase = SetSettings(mockSettingsRepository);
  });

  final tSettingsModel = SettingsModel(
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
    'should set and then get the currently set settings from the repository',
    () async {
      // arrange
      when(mockSettingsRepository.setSettings(any))
          .thenAnswer((_) async => Right(tSettingsModel));
      // act
      final result = await usecase(
        Params(settings: tSettingsModel),
      );
      // assert
      expect(result, Right(tSettingsModel));
      verify(mockSettingsRepository.setSettings(tSettingsModel));
      verifyNoMoreInteractions(mockSettingsRepository);
    },
  );
}
