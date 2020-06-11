import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:Weader/features/time_aware_wallpaper/domain/entity/time_aware_wallpaper.dart';
import 'package:Weader/features/time_aware_wallpaper/domain/repository/time_aware_wallpaper_repository.dart';
import 'package:Weader/features/time_aware_wallpaper/domain/usecases/get_wallpaper.dart';

class MockTimeAwareWallpaperRepository extends Mock
    implements TimeAwareWallpaperRepository {}

void main() {
  GetWallpaper usecase;
  MockTimeAwareWallpaperRepository mockTimeAwareWallpaperRepository;

  setUp(() {
    mockTimeAwareWallpaperRepository = MockTimeAwareWallpaperRepository();
    usecase = GetWallpaper(mockTimeAwareWallpaperRepository);
  });

  final tTime = 'time';
  final tTimeAwareWallpaper = TimeAwareWallpaper("url");

  test(
    'should return url from repository for time',
    () async {
      // arrange
      when(mockTimeAwareWallpaperRepository.getWallpaper(any))
          .thenAnswer((_) async => Right(tTimeAwareWallpaper));
      // act
      final result = await usecase(Params(time: tTime));
      // assert
      expect(result, Right(tTimeAwareWallpaper));
      verify(mockTimeAwareWallpaperRepository.getWallpaper(tTime));
      verifyNoMoreInteractions(mockTimeAwareWallpaperRepository);
    },
  );
}
