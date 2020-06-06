import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/themes/themes.dart';
import 'core/widgets/error_display.dart';
import 'features/locations/presentation/pages/locations_pages.dart';
import 'features/settings/presentation/bloc/bloc.dart';
import 'injector.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.getIt<SettingsBloc>(),
      child: App(),
    );
  }
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<SettingsBloc>(context).add(GetSettingsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(builder: (
      context,
      state,
    ) {
      ThemeData theme() {
        if (state is SettingsLoaded) {
          if (state.settings.currentTheme.isDark)
            return appThemeData[AppTheme.Dark];
        }
        return appThemeData[AppTheme.Light];
      }

      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weader',
        theme: theme(),
        home: SearchPage(),
      );
    });
  }
}
