import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weader/features/locations/data/data_sources/locations_data_source.dart';
import 'package:weader/features/locations/data/repository/locations_repository_impl.dart';
import 'package:weader/features/locations/domain/repository/locations_repository.dart';

import 'core/util/input_checker.dart';
import 'features/locations/domain/usecases/get_device_locations_list.dart';
import 'features/locations/domain/usecases/get_locations_list.dart';
import 'features/locations/presentation/bloc/bloc.dart';

final GetIt getIt = GetIt.instance;

init() {
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
    ),
  );

  // data sources
  getIt.registerLazySingleton<LocationsDataSource>(
    () => LocationsDataSourceImpl(
      geolocator: getIt(),
    ),
  );

  //! Core
  getIt.registerLazySingleton(
    () => InputChecker(),
  );
}
