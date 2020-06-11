import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:Weader/core/error/exception.dart';
import 'package:Weader/core/error/failures.dart';
import 'package:Weader/core/network/network_info.dart';
import 'package:Weader/features/time_aware_wallpaper/data/datasources/time_aware_wallpaper_remote_data_source.dart';
import 'package:Weader/features/time_aware_wallpaper/data/models/time_aware_wallpaper_model.dart';
import 'package:Weader/features/time_aware_wallpaper/data/repository/time_aware_wallpaper_repository_impl.dart';

class MockRemoteDataSource extends Mock
    implements TimeAwareWallpaperRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  TimeAwareWallpaperRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = TimeAwareWallpaperRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group(
    'getWallpaper',
    () {
      final tTime = 'morning';
      final tTimeAwareWallpaperModel = TimeAwareWallpaperModel("url");

      test(
        'should check if the device is online',
        () async {
          // arrange
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          // act
          repository.getWallpaper(tTime);
          // assert
          verify(mockNetworkInfo.isConnected);
        },
      );

      test(
        'should return network failure when device is offline',
        () async {
          // arrange
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
          // act
          final result = await repository.getWallpaper(tTime);

          // assert
          expect(result, equals(Left(NetworkFailure())));
        },
      );

      group(
        "device is online",
        () {
          setUp(() {
            when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          });

          test(
            'should return remote data when the call to remote data source is successfull',
            () async {
              // arrange
              when(mockRemoteDataSource.getWallpaper(tTime))
                  .thenAnswer((_) async => tTimeAwareWallpaperModel);
              // act
              final result = await repository.getWallpaper(tTime);
              // assert
              verify(mockRemoteDataSource.getWallpaper(tTime));
              expect(result, Right(tTimeAwareWallpaperModel));
            },
          );

          test(
            'should return server failure when the call to remote data source is unsuccessful',
            () async {
              // arrange
              when(mockRemoteDataSource.getWallpaper(tTime))
                  .thenThrow(ServerException());
              // act
              final result = await repository.getWallpaper(tTime);
              // assert
              verify(mockRemoteDataSource.getWallpaper(tTime));
              expect(result, equals(Left(ServerFailure())));
            },
          );
        },
      );
    },
  );
}
