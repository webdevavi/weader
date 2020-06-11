import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:Weader/core/error/failures.dart';
import 'package:Weader/features/time_aware_wallpaper/domain/entity/time_aware_wallpaper.dart';
import 'package:Weader/features/time_aware_wallpaper/domain/usecases/get_wallpaper.dart';
import 'package:Weader/features/time_aware_wallpaper/presentation/bloc/bloc.dart';

class MockGetWallpaper extends Mock implements GetWallpaper {}

void main() {
  TimeAwareWallpaperBloc bloc;
  MockGetWallpaper mockGetWallpaper;

  setUp(() {
    mockGetWallpaper = MockGetWallpaper();
    bloc = TimeAwareWallpaperBloc(mockGetWallpaper);
  });

  group(
    'TimeawareWallpaperBloc',
    () {
      test(
        'initial state should be empty',
        () {
          // assert
          expect(bloc.initialState, equals(TimeAwareWallpaperEmpty()));
        },
      );

      final tTime = "morning";
      final tTimeAwareWallpaper = TimeAwareWallpaper("url");

      blocTest(
        'should get data from the get wallpaper usecase',
        build: () async {
          when(mockGetWallpaper(any))
              .thenAnswer((_) async => Right(tTimeAwareWallpaper));
          return TimeAwareWallpaperBloc(mockGetWallpaper);
        },
        act: (bloc) => bloc.add(GetWallpaperEvent(tTime)),
        verify: (_) async => verify(mockGetWallpaper(Params(time: tTime))),
      );

      blocTest(
        'should emit [Loading, Loaded] when data is gotten successfully',
        build: () async {
          when(mockGetWallpaper(any))
              .thenAnswer((_) async => Right(tTimeAwareWallpaper));
          return TimeAwareWallpaperBloc(mockGetWallpaper);
        },
        act: (bloc) => bloc.add(GetWallpaperEvent(tTime)),
        expect: [
          TimeAwareWallpaperLoading(),
          TimeAwareWallpaperLoaded(timeAwareWallpaper: tTimeAwareWallpaper),
        ],
      );

      blocTest(
        'should emit [Loading, Error] when getting data fails',
        build: () async {
          when(mockGetWallpaper(any)).thenAnswer(
            (_) async => Left(
              ServerFailure(),
            ),
          );
          return TimeAwareWallpaperBloc(mockGetWallpaper);
        },
        act: (bloc) => bloc.add(GetWallpaperEvent(tTime)),
        expect: [
          TimeAwareWallpaperLoading(),
          TimeAwareWallpaperError(
            message: SERVER_FAILURE_MESSAGE,
          ),
        ],
      );
    },
  );
}
