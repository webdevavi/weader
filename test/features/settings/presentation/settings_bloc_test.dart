import 'package:Weader/features/settings/domain/usecases/switch_current_theme.dart';
import 'package:Weader/features/settings/domain/usecases/switch_data_preference.dart';
import 'package:Weader/features/settings/domain/usecases/switch_time_format.dart';
import 'package:Weader/features/settings/domain/usecases/switch_unit_system.dart';
import 'package:Weader/features/settings/domain/usecases/switch_wallpaper.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:Weader/core/entities/settings.dart';
import 'package:Weader/core/error/failures.dart';
import 'package:Weader/core/settings/initial_settings.dart';
import 'package:Weader/core/usecases/usecase.dart';
import 'package:Weader/features/settings/domain/usecases/get_settings.dart';
import 'package:Weader/features/settings/presentation/bloc/bloc.dart';

class MockGetSettings extends Mock implements GetSettings {}

class MockSwitchUnitSystem extends Mock implements SwitchUnitSystem {}

class MockSwitchTimeFormat extends Mock implements SwitchTimeFormat {}

class MockSwitchDataPreference extends Mock implements SwitchDataPreference {}

class MockSwitchCurrentTheme extends Mock implements SwitchCurrentTheme {}

class MockSwitchWallpaper extends Mock implements SwitchWallpaper {}

void main() {
  MockGetSettings mockGetSettings;
  MockSwitchUnitSystem mockSwitchUnitSystem;
  MockSwitchTimeFormat mockSwitchTimeFormat;
  MockSwitchDataPreference mockSwitchDataPreference;
  MockSwitchCurrentTheme mockSwitchCurrentTheme;
  MockSwitchWallpaper mockSwitchWallpaper;
  SettingsBloc bloc;

  SettingsBloc returnBloc() {
    return SettingsBloc(
      getSettings: mockGetSettings,
      switchUnitSystem: mockSwitchUnitSystem,
      switchTimeFormat: mockSwitchTimeFormat,
      switchDataPreference: mockSwitchDataPreference,
      switchCurrentTheme: mockSwitchCurrentTheme,
      switchWallpaper: mockSwitchWallpaper,
    );
  }

  setUp(() {
    mockGetSettings = MockGetSettings();
    mockSwitchUnitSystem = MockSwitchUnitSystem();
    mockSwitchTimeFormat = MockSwitchTimeFormat();
    mockSwitchDataPreference = MockSwitchDataPreference();
    mockSwitchCurrentTheme = MockSwitchCurrentTheme();
    mockSwitchWallpaper = MockSwitchWallpaper();
    bloc = returnBloc();
  });

  final tSettings = Settings(
    unitSystem: UnitSystem(isImperial: false),
    timeFormat: TimeFormat(is24Hours: false),
    dataPreference: DataPreference(isLocal: false),
    currentTheme: CurrentTheme(isDark: false),
    wallpaper: Wallpaper(isTimeAware: false),
  );

  group('SettingsBloc', () {
    test("initial state should be SettingsLoaded with initialSettings", () {
      expect(
        bloc.initialState,
        equals(SettingsLoaded(settings: initialSettings)),
      );
    });

    group('GetSettingsEvent', () {
      blocTest(
        'should get data from the get settings usecase',
        build: () async {
          when(mockGetSettings(any)).thenAnswer((_) async => Right(tSettings));
          return returnBloc();
        },
        act: (bloc) => bloc.add(GetSettingsEvent()),
        verify: (_) async => verify(mockGetSettings(NoParams())),
      );

      blocTest(
        'should emit [Loaded] when data is gotten successfully',
        build: () async {
          when(mockGetSettings(any)).thenAnswer((_) async => Right(tSettings));
          return returnBloc();
        },
        act: (bloc) => bloc.add(GetSettingsEvent()),
        expect: [SettingsLoaded(settings: tSettings)],
      );

      blocTest(
        'should emit [Error] when getting data fails',
        build: () async {
          when(mockGetSettings(any)).thenAnswer(
            (_) async => Left(
              UnexpectedFailure(),
            ),
          );
          return returnBloc();
        },
        act: (bloc) => bloc.add(GetSettingsEvent()),
        expect: [SettingsError(message: UNEXPECTED_FAILURE_MESSAGE)],
      );
    });

    group('SwitchUnitSystemEvent', () {
      final tUnitSystem = UnitSystem(isImperial: false);
      blocTest(
        'should get data from the switch unit system usecase',
        build: () async {
          when(mockSwitchUnitSystem(any))
              .thenAnswer((_) async => Right(tSettings));
          return returnBloc();
        },
        act: (bloc) => bloc.add(SwitchUnitSystemEvent(tUnitSystem)),
        verify: (_) async =>
            verify(mockSwitchUnitSystem(SwitchUnitSystemParams(tUnitSystem))),
      );

      blocTest(
        'should emit [Loaded] when data is gotten successfully',
        build: () async {
          when(mockSwitchUnitSystem(any))
              .thenAnswer((_) async => Right(tSettings));
          return returnBloc();
        },
        act: (bloc) => bloc.add(SwitchUnitSystemEvent(tUnitSystem)),
        expect: [SettingsLoaded(settings: tSettings)],
      );

      blocTest(
        'should emit [Error] when getting data fails',
        build: () async {
          when(mockSwitchUnitSystem(any))
              .thenAnswer((_) async => Left(UnexpectedFailure()));
          return returnBloc();
        },
        act: (bloc) => bloc.add(SwitchUnitSystemEvent(tUnitSystem)),
        expect: [SettingsError(message: UNEXPECTED_FAILURE_MESSAGE)],
      );
    });

    group('SwitchTimeFormatEvent', () {
      final tTimeFormat = TimeFormat(is24Hours: false);
      blocTest(
        'should get data from the switch unit system usecase',
        build: () async {
          when(mockSwitchTimeFormat(any))
              .thenAnswer((_) async => Right(tSettings));
          return returnBloc();
        },
        act: (bloc) => bloc.add(SwitchTimeFormatEvent(tTimeFormat)),
        verify: (_) async =>
            verify(mockSwitchTimeFormat(SwitchTimeFormatParams(tTimeFormat))),
      );

      blocTest(
        'should emit [Loaded] when data is gotten successfully',
        build: () async {
          when(mockSwitchTimeFormat(any))
              .thenAnswer((_) async => Right(tSettings));
          return returnBloc();
        },
        act: (bloc) => bloc.add(SwitchTimeFormatEvent(tTimeFormat)),
        expect: [SettingsLoaded(settings: tSettings)],
      );

      blocTest(
        'should emit [Error] when getting data fails',
        build: () async {
          when(mockSwitchTimeFormat(any))
              .thenAnswer((_) async => Left(UnexpectedFailure()));
          return returnBloc();
        },
        act: (bloc) => bloc.add(SwitchTimeFormatEvent(tTimeFormat)),
        expect: [SettingsError(message: UNEXPECTED_FAILURE_MESSAGE)],
      );
    });

    group('SwitchDataPreferenceEvent', () {
      final tDataPreference = DataPreference(isLocal: false);
      blocTest(
        'should get data from the switch unit system usecase',
        build: () async {
          when(mockSwitchDataPreference(any))
              .thenAnswer((_) async => Right(tSettings));
          return returnBloc();
        },
        act: (bloc) => bloc.add(SwitchDataPreferenceEvent(tDataPreference)),
        verify: (_) async => verify(
          mockSwitchDataPreference(SwitchDataPreferenceParams(tDataPreference)),
        ),
      );

      blocTest(
        'should emit [Loaded] when data is gotten successfully',
        build: () async {
          when(mockSwitchDataPreference(any))
              .thenAnswer((_) async => Right(tSettings));
          return returnBloc();
        },
        act: (bloc) => bloc.add(SwitchDataPreferenceEvent(tDataPreference)),
        expect: [SettingsLoaded(settings: tSettings)],
      );

      blocTest(
        'should emit [Error] when getting data fails',
        build: () async {
          when(mockSwitchDataPreference(any))
              .thenAnswer((_) async => Left(UnexpectedFailure()));
          return returnBloc();
        },
        act: (bloc) => bloc.add(SwitchDataPreferenceEvent(tDataPreference)),
        expect: [SettingsError(message: UNEXPECTED_FAILURE_MESSAGE)],
      );
    });

    group('SwitchCurrentThemeEvent', () {
      final tCurrentTheme = CurrentTheme(isDark: false);
      blocTest(
        'should get data from the switch unit system usecase',
        build: () async {
          when(mockSwitchCurrentTheme(any))
              .thenAnswer((_) async => Right(tSettings));
          return returnBloc();
        },
        act: (bloc) => bloc.add(SwitchCurrentThemeEvent(tCurrentTheme)),
        verify: (_) async => verify(
          mockSwitchCurrentTheme(SwitchCurrentThemeParams(tCurrentTheme)),
        ),
      );

      blocTest(
        'should emit [Loaded] when data is gotten successfully',
        build: () async {
          when(mockSwitchCurrentTheme(any))
              .thenAnswer((_) async => Right(tSettings));
          return returnBloc();
        },
        act: (bloc) => bloc.add(SwitchCurrentThemeEvent(tCurrentTheme)),
        expect: [SettingsLoaded(settings: tSettings)],
      );

      blocTest(
        'should emit [Error] when getting data fails',
        build: () async {
          when(mockSwitchCurrentTheme(any))
              .thenAnswer((_) async => Left(UnexpectedFailure()));
          return returnBloc();
        },
        act: (bloc) => bloc.add(SwitchCurrentThemeEvent(tCurrentTheme)),
        expect: [SettingsError(message: UNEXPECTED_FAILURE_MESSAGE)],
      );
    });

    group('SwitchWallpaperEvent', () {
      final tWallpaper = Wallpaper(isTimeAware: false);
      blocTest(
        'should get data from the switch unit system usecase',
        build: () async {
          when(mockSwitchWallpaper(any))
              .thenAnswer((_) async => Right(tSettings));
          return returnBloc();
        },
        act: (bloc) => bloc.add(SwitchWallpaperEvent(tWallpaper)),
        verify: (_) async => verify(
          mockSwitchWallpaper(SwitchWallpaperParams(tWallpaper)),
        ),
      );

      blocTest(
        'should emit [Loaded] when data is gotten successfully',
        build: () async {
          when(mockSwitchWallpaper(any))
              .thenAnswer((_) async => Right(tSettings));
          return returnBloc();
        },
        act: (bloc) => bloc.add(SwitchWallpaperEvent(tWallpaper)),
        expect: [SettingsLoaded(settings: tSettings)],
      );

      blocTest(
        'should emit [Error] when getting data fails',
        build: () async {
          when(mockSwitchWallpaper(any))
              .thenAnswer((_) async => Left(UnexpectedFailure()));
          return returnBloc();
        },
        act: (bloc) => bloc.add(SwitchWallpaperEvent(tWallpaper)),
        expect: [SettingsError(message: UNEXPECTED_FAILURE_MESSAGE)],
      );
    });
  });
}
