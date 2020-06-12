import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';
import 'features/save_locations/presentation/bloc/bloc.dart';
import 'features/search_locations/presentation/bloc/bloc.dart';
import 'features/settings/presentation/bloc/bloc.dart';
import 'features/time_aware_wallpaper/presentation/bloc/bloc.dart';
import 'features/weather_for_one_location/presentation/bloc/bloc.dart';
import 'features/weather_for_saved_locations/presentation/bloc/bloc.dart';
import 'injector.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (context) => di.getIt<SettingsBloc>()),
      BlocProvider(create: (context) => di.getIt<SearchLocationsBloc>()),
      BlocProvider(create: (context) => di.getIt<WeatherForOneLocationBloc>()),
      BlocProvider(
        create: (context) => di.getIt<WeatherForSavedLocationsBloc>(),
      ),
      BlocProvider(create: (context) => di.getIt<TimeAwareWallpaperBloc>()),
      BlocProvider(create: (context) => di.getIt<SaveLocationsBloc>()),
    ], child: App());
  }
}
