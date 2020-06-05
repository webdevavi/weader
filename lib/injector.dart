import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart';
import 'package:weader/core/network/network_info.dart';
import 'package:weader/features/locations/data/data_sources/locations_data_source.dart';
import 'package:weader/features/locations/data/repository/locations_repository_impl.dart';
import 'package:weader/features/locations/domain/repository/locations_repository.dart';
import 'package:weader/features/time_aware_wallpaper/domain/repository/time_aware_wallpaper_repository.dart';
import 'package:weader/features/time_aware_wallpaper/domain/usecases/get_wallpaper.dart';
import 'package:weader/features/time_aware_wallpaper/presentation/bloc/bloc.dart';
import 'package:weader/features/weather/data/data_sources/weather_remote_data_source.dart';
import 'package:weader/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:weader/features/weather/domain/repositories/weather_repository.dart';
import 'package:weader/features/weather/domain/usecases/get_weather.dart';
import 'package:weader/features/weather/presentation/bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'core/util/datetime_converter.dart';
import 'core/util/input_checker.dart';
import 'core/util/unit_converter.dart';
import 'features/locations/domain/usecases/get_device_locations_list.dart';
import 'features/locations/domain/usecases/get_locations_list.dart';
import 'features/locations/presentation/bloc/bloc.dart';
import 'features/time_aware_wallpaper/data/datasources/time_aware_wallpaper_remote_data_source.dart';
import 'features/time_aware_wallpaper/data/repository/time_aware_wallpaper_repository_impl.dart';

final GetIt getIt = GetIt.instance;

Future<void> init() async {
  //! External
  getIt.registerLazySingletonAsync(
    () => SharedPreferences.getInstance(),
  );

  getIt.registerLazySingleton(
    () => Geolocator(),
  );

  getIt.registerLazySingleton(
    () => DataConnectionChecker(),
  );

  getIt.registerLazySingleton(
    () => http.Client(),
  );

  //! Features - Locations
  // BLoC
  getIt.registerFactory(
    () => LocationsBloc(
      getDeviceLocationsList: getIt(),
      getLocationsList: getIt(),
      inputChecker: getIt(),
    ),
  );

  // usecases
  getIt.registerLazySingleton(
    () => GetDeviceLocationsList(
      getIt(),
    ),
  );

  getIt.registerLazySingleton(
    () => GetLocationsList(
      getIt(),
    ),
  );

  // repository
  getIt.registerLazySingleton<LocationsRepository>(
    () => LocationsRepositoryImpl(
      dataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  // data sources
  getIt.registerLazySingleton<LocationsDataSource>(
    () => LocationsDataSourceImpl(
      geolocator: getIt(),
    ),
  );

  //! Features - Weather
  // BLoC
  getIt.registerFactory(
    () => WeatherBloc(
      getIt(),
    ),
  );

  // usecase
  getIt.registerLazySingleton(
    () => GetWeather(
      getIt(),
    ),
  );

  // repository
  getIt.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  // datasources
  getIt.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSourceImpl(
      client: getIt(),
    ),
  );

  //! Features - Time Aware Wallpaper
  // BLoC
  getIt.registerFactory(
    () => TimeAwareWallpaperBloc(
      getIt(),
    ),
  );

  // usecase
  getIt.registerLazySingleton(
    () => GetWallpaper(
      getIt(),
    ),
  );

  // repository
  getIt.registerLazySingleton<TimeAwareWallpaperRepository>(
    () => TimeAwareWallpaperRepositoryImpl(
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  // datasources
  getIt.registerLazySingleton<TimeAwareWallpaperRemoteDataSource>(
    () => TimeAwareWallpaperRemoteDataSourceImpl(
      client: getIt(),
    ),
  );

  //! Core
  getIt.registerLazySingleton(
    () => InputChecker(),
  );

  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      getIt(),
    ),
  );

  getIt.registerLazySingleton(
    () => DateTimeConverter(),
  );

  getIt.registerLazySingleton(
    () => UnitConverter(),
  );

  Future<void> initTZ() async {
    var byteData = await rootBundle.load('packages/timezone/data/2020a.tzf');
    initializeDatabase(byteData.buffer.asUint8List());
  }

  await initTZ();
}
