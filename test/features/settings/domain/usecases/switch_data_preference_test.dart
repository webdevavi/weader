import 'package:Weader/features/settings/domain/usecases/switch_data_preference.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:Weader/core/entities/settings.dart';
import 'package:Weader/features/settings/data/models/settings_model.dart';
import 'package:Weader/features/settings/domain/repository/settings_repository.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  SwitchDataPreference usecase;
  MockSettingsRepository mockSettingsRepository;

  setUp(() {
    mockSettingsRepository = MockSettingsRepository();
    usecase = SwitchDataPreference(mockSettingsRepository);
  });

  final tDataPrefernce = DataPreference(isLocal: false);

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
      when(mockSettingsRepository.switchDataPreference(any))
          .thenAnswer((_) async => Right(tSettingsModel));
      // act
      final result = await usecase(
        SwitchDataPreferenceParams(tDataPrefernce),
      );
      // assert
      expect(result, Right(tSettingsModel));
      verify(mockSettingsRepository.switchDataPreference(tDataPrefernce));
      verifyNoMoreInteractions(mockSettingsRepository);
    },
  );
}
