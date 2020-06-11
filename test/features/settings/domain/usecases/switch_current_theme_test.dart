import 'package:Weader/features/settings/domain/usecases/switch_current_theme.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:Weader/core/entities/settings.dart';
import 'package:Weader/features/settings/data/models/settings_model.dart';
import 'package:Weader/features/settings/domain/repository/settings_repository.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  SwitchCurrentTheme usecase;
  MockSettingsRepository mockSettingsRepository;

  setUp(() {
    mockSettingsRepository = MockSettingsRepository();
    usecase = SwitchCurrentTheme(mockSettingsRepository);
  });

  final tCurrentTheme = CurrentTheme(isDark: false);

  final tSettingsModel = SettingsModel(
    unitSystem: UnitSystem(
      isImperial: false,
    ),
    timeFormat: TimeFormat(
      is24Hours: false,
    ),
    dataPreference: DataPreference(
      isLocal: false,
    ),
    currentTheme: CurrentTheme(
      isDark: false,
    ),
    wallpaper: Wallpaper(
      isTimeAware: false,
    ),
  );

  test(
    'should get the currently set settings from the repository',
    () async {
      // arrange
      when(mockSettingsRepository.switchCurrentTheme(any))
          .thenAnswer((_) async => Right(tSettingsModel));
      // act
      final result = await usecase(
        SwitchCurrentThemeParams(tCurrentTheme),
      );
      // assert
      expect(result, Right(tSettingsModel));
      verify(mockSettingsRepository.switchCurrentTheme(tCurrentTheme));
      verifyNoMoreInteractions(mockSettingsRepository);
    },
  );
}
