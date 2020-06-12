import 'package:Weader/core/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/pages/home_page.dart';
import 'core/pages/splash_page.dart';
import 'features/settings/presentation/bloc/bloc.dart';

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
      if (state is SettingsLoading)
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Weader',
          home: SplashPage(),
        );
      else if (state is SettingsLoaded)
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Weader',
          theme: _getTheme(state),
          home: HomePage(),
        );
    });
  }

  ThemeData _getTheme(SettingsLoaded state) {
    if (state.settings.currentTheme.isDark) return appThemeData[AppTheme.Dark];
    return appThemeData[AppTheme.Light];
  }
}
