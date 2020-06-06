import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weader/core/entities/settings.dart';
import 'package:weader/core/error/failures.dart';
import 'package:weader/core/settings/initial_settings.dart';
import 'package:weader/core/usecases/usecase.dart';
import 'package:weader/features/settings/domain/usecases/get_settings.dart';
import 'package:weader/features/settings/domain/usecases/set_settings.dart';
import 'package:weader/features/settings/presentation/bloc/bloc.dart';

class MockGetSettings extends Mock implements GetSettings {}

class MockSetSettings extends Mock implements SetSettings {}

void main() {
  MockGetSettings mockGetSettings;
  MockSetSettings mockSetSettings;
  SettingsBloc bloc;

  SettingsBloc returnBloc() {
    return SettingsBloc(
      getSettings: mockGetSettings,
      setSettings: mockSetSettings,
    );
  }

  setUp(() {
    mockGetSettings = MockGetSettings();
    mockSetSettings = MockSetSettings();

    bloc = returnBloc();
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

  group('SettingsBloc', () {
    test("initial state should be SettingsLoaded with initialSettings", () {
      expect(
        bloc.initialState,
        equals(
          SettingsLoaded(
            settings: initialSettings,
          ),
        ),
      );
    });

    group('GetSettingsEvent', () {
      blocTest(
        'should get data from the get settings usecase',
        build: () async {
          when(mockGetSettings(any)).thenAnswer((_) async => Right(tSettings));
          return returnBloc();
        },
        act: (bloc) => bloc.add(
          GetSettingsEvent(),
        ),
        verify: (_) async => verify(
          mockGetSettings(NoParams()),
        ),
      );

      blocTest(
        'should emit [Loaded] when data is gotten successfully',
        build: () async {
          when(mockGetSettings(any)).thenAnswer((_) async => Right(tSettings));
          return returnBloc();
        },
        act: (bloc) => bloc.add(GetSettingsEvent()),
        expect: [
          SettingsLoaded(settings: tSettings),
        ],
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
        expect: [
          SettingsError(
            message: UNEXPECTED_FAILURE_MESSAGE,
          ),
        ],
      );
    });

    group('SetSettingsEvent', () {
      blocTest(
        'should get data from the set settings usecase',
        build: () async {
          when(mockSetSettings(any)).thenAnswer((_) async => Right(tSettings));
          return returnBloc();
        },
        act: (bloc) => bloc.add(
          SetSettingsEvent(tSettings),
        ),
        verify: (_) async => verify(
          mockSetSettings(Params(settings: tSettings)),
        ),
      );

      blocTest(
        'should emit [Loaded] when data is gotten successfully',
        build: () async {
          when(mockSetSettings(any)).thenAnswer((_) async => Right(tSettings));
          return returnBloc();
        },
        act: (bloc) => bloc.add(
          SetSettingsEvent(tSettings),
        ),
        expect: [
          SettingsLoaded(settings: tSettings),
        ],
      );

      blocTest(
        'should emit [Error] when getting data fails',
        build: () async {
          when(mockSetSettings(any)).thenAnswer(
            (_) async => Left(
              UnexpectedFailure(),
            ),
          );
          return returnBloc();
        },
        act: (bloc) => bloc.add(
          SetSettingsEvent(tSettings),
        ),
        expect: [
          SettingsError(
            message: UNEXPECTED_FAILURE_MESSAGE,
          ),
        ],
      );
    });
  });
}
