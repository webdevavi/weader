import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart';
import 'package:uuid/uuid.dart';

import 'core/app_info/app_info.dart';
import 'core/data_sources/weather_remote_data_source.dart';
import 'core/network/network_info.dart';
import 'core/util/datetime_converter.dart';
import 'core/util/input_checker.dart';
import 'core/util/unique_id_generator.dart';
import 'features/save_locations/data/data_sources/save_locations_local_data_source.dart';
import 'features/save_locations/data/repository/save_locations_repository_impl.dart';
import 'features/save_locations/domain/repository/save_locations_repository.dart';
import 'features/save_locations/domain/usecases/save_locations_usecases.dart';
import 'features/save_locations/presentation/bloc/bloc.dart';
import 'features/search_locations/data/data_sources/search_locations_local_data_source.dart';
import 'features/search_locations/data/data_sources/search_locations_remote_data_source.dart';
import 'features/search_locations/data/repository/search_locations_repository_impl.dart';
import 'features/search_locations/domain/repository/search_locations_repository.dart';
import 'features/search_locations/domain/usecases/search_locations_usecases.dart';
import 'features/search_locations/presentation/bloc/bloc.dart';
import 'features/settings/data/data_sources/settings_local_data_source.dart';
import 'features/settings/data/repository/settings_repository_impl.dart';
import 'features/settings/domain/repository/settings_repository.dart';
import 'features/settings/domain/usecases/settings_usecases.dart';
import 'features/settings/presentation/bloc/bloc.dart';
import 'features/time_aware_wallpaper/data/datasources/time_aware_wallpaper_remote_data_source.dart';
import 'features/time_aware_wallpaper/data/repository/time_aware_wallpaper_repository_impl.dart';
import 'features/time_aware_wallpaper/domain/repository/time_aware_wallpaper_repository.dart';
import 'features/time_aware_wallpaper/domain/usecases/get_wallpaper.dart';
import 'features/time_aware_wallpaper/presentation/bloc/bloc.dart';
import 'features/weather_for_one_location/data/repositories/weather_for_one_location_repository_impl.dart';
import 'features/weather_for_one_location/domain/repositories/weather_for_one_location_repository.dart';
import 'features/weather_for_one_location/domain/usecases/get_weather_for_one_location.dart';
import 'features/weather_for_one_location/presentation/bloc/bloc.dart';
import 'features/weather_for_saved_locations/data/repositories/weather_for_saved_locations_repository_impl.dart';
import 'features/weather_for_saved_locations/domain/repositories/weather_for_saved_locations_repository.dart';
import 'features/weather_for_saved_locations/domain/usecases/get_weather_for_saved_locations.dart';
import 'features/weather_for_saved_locations/presentation/bloc/bloc.dart';

final GetIt getIt = GetIt.instance;

Future<void> init() async {
  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);

  getIt.registerLazySingleton(() => Geolocator());

  getIt.registerLazySingleton(() => DataConnectionChecker());

  getIt.registerLazySingleton(() => http.Client());

  getIt.registerLazySingleton(() => Uuid());

  final PackageInfo packageInfo = await PackageInfo.fromPlatform();
  getIt.registerLazySingleton(() => packageInfo);

  //! Features - Search Locations
  // BLoC
  getIt.registerFactory(
    () => SearchLocationsBloc(
      getLocationsList: getIt(),
      getRecentlySearchedLocationsList: getIt(),
      inputChecker: getIt(),
      clearAllRecentlySearchedLocationsList: getIt(),
      clearOneRecentlySearchedLocation: getIt(),
    ),
  );

  // usecases

  getIt.registerLazySingleton(() => GetLocationsList(getIt()));

  getIt.registerLazySingleton(
    () => GetRecentlySearchedLocationsList(getIt()),
  );

  getIt.registerLazySingleton(
    () => ClearOneRecentlySearchedLocation(getIt()),
  );

  getIt.registerLazySingleton(
    () => ClearAllRecentlySearchedLocationsList(getIt()),
  );

  // repository
  getIt.registerLazySingleton<SearchLocationsRepository>(
    () => SearchLocationsRepositoryImpl(
      dataSource: getIt(),
      networkInfo: getIt(),
      localDataSource: getIt(),
    ),
  );

  // data sources
  getIt.registerLazySingleton<SearchLocationsRemoteDataSource>(
    () => SearchLocationsRemoteDataSourceImpl(
      geolocator: getIt(),
      uniqueIdGenerator: getIt(),
    ),
  );

  getIt.registerLazySingleton<SearchLocationsLocalDataSource>(
    () => SearchLocationsLocalDataSourceImpl(sharedPreferences: getIt()),
  );

  //! Features - Save Locations
  // BLoC
  getIt.registerFactory(
    () => SaveLocationsBloc(
      saveLocation: getIt(),
      getSavedLocations: getIt(),
      deleteSavedLocation: getIt(),
      deleteAllSavedLocations: getIt(),
    ),
  );

  // usecases

  getIt.registerLazySingleton(() => SaveLocation(getIt()));

  getIt.registerLazySingleton(() => GetSavedLocations(getIt()));

  getIt.registerLazySingleton(() => DeleteSavedLocation(getIt()));

  getIt.registerLazySingleton(() => DeleteAllSavedLocations(getIt()));

  // repository
  getIt.registerLazySingleton<SaveLocationsRepository>(
    () => SaveLocationsRepositoryImpl(localDataSource: getIt()),
  );

  // data sources
  getIt.registerLazySingleton<SaveLocationsLocalDataSource>(
    () => SaveLocationsLocalDataSourceImpl(sharedPreferences: getIt()),
  );

  //! Features - Weather For One Location
  // BLoC
  getIt.registerFactory(() => WeatherForOneLocationBloc(getIt()));

  // usecase
  getIt.registerLazySingleton(() => GetWeatherForOneLocation(getIt()));

  // repository
  getIt.registerLazySingleton<WeatherForOneLocationRepository>(
    () => WeatherForOneLocationRepositoryImpl(
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  //! Features - Weather For Saved Locations
  // BLoC
  getIt.registerFactory(() => WeatherForSavedLocationsBloc(getIt()));

  // usecase
  getIt.registerLazySingleton(() => GetWeatherForSavedLocations(getIt()));

  // repository
  getIt.registerLazySingleton<WeatherForSavedLocationsRepository>(
    () => WeatherForSavedLocationsRepositoryImpl(
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  //! Features - Time Aware Wallpaper
  // BLoC
  getIt.registerFactory(() => TimeAwareWallpaperBloc(getIt()));

  // usecase
  getIt.registerLazySingleton(() => GetWallpaper(getIt()));

  // repository
  getIt.registerLazySingleton<TimeAwareWallpaperRepository>(
    () => TimeAwareWallpaperRepositoryImpl(
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  // datasources
  getIt.registerLazySingleton<TimeAwareWallpaperRemoteDataSource>(
    () => TimeAwareWallpaperRemoteDataSourceImpl(client: getIt()),
  );

  //! Features - Settings
  // BLoC
  getIt.registerFactory(
    () => SettingsBloc(
      getSettings: getIt(),
      switchCurrentTheme: getIt(),
      switchDataPreference: getIt(),
      switchTimeFormat: getIt(),
      switchUnitSystem: getIt(),
      switchWallpaper: getIt(),
    ),
  );

  // usecase
  getIt.registerLazySingleton(() => GetSettings(getIt()));

  getIt.registerLazySingleton(() => SwitchUnitSystem(getIt()));

  getIt.registerLazySingleton(() => SwitchTimeFormat(getIt()));

  getIt.registerLazySingleton(() => SwitchDataPreference(getIt()));

  getIt.registerLazySingleton(() => SwitchCurrentTheme(getIt()));

  getIt.registerLazySingleton(() => SwitchWallpaper(getIt()));

  // repository
  getIt.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(getIt()),
  );

  // datasources
  getIt.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(sharedPreferences: getIt()),
  );

  //! Core
  getIt.registerLazySingleton(() => InputChecker());

  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));

  getIt.registerLazySingleton(() => DateTimeConverter());

  getIt.registerLazySingleton(() => UniqueIdGenerator(getIt()));

  Future<void> initTZ() async {
    var byteData = await rootBundle.load('packages/timezone/data/2020a.tzf');
    initializeDatabase(byteData.buffer.asUint8List());
  }

  await initTZ();

  // datasources
  getIt.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSourceImpl(
      client: getIt(),
      dateTimeConverter: getIt(),
    ),
  );

  getIt.registerLazySingleton(() => AppInfo.get(getIt()));
}
