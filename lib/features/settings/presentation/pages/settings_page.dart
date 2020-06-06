import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weader/core/entities/settings.dart';
import 'package:weader/core/widgets/widgets.dart';
import 'package:weader/features/settings/data/models/settings_model.dart';

import '../bloc/bloc.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state is SettingsLoaded)
          return Scaffold(
            appBar: AppBar(
              title: Text("Settings"),
            ),
            body: ListView(
              children: <Widget>[
                ListTile(
                  title: Text("Show units in Imperial Unit System"),
                  subtitle: Text("Metric Unit System is used by default"),
                  trailing: Switch(
                      value: state.settings.unitSystem.isImperial,
                      onChanged: (value) {
                        BlocProvider.of<SettingsBloc>(context)
                            .add(SetSettingsEvent(
                          SettingsModel(
                            unitSystem: UnitSystem(isImperial: value),
                            timeFormat: TimeFormat(
                              is24Hours: state.settings.timeFormat.is24Hours,
                            ),
                            dataPreference: DataPreference(
                              isLocal: state.settings.dataPreference.isLocal,
                            ),
                            currentTheme: CurrentTheme(
                              isDark: state.settings.currentTheme.isDark,
                            ),
                            wallpaper: Wallpaper(
                              isTimeAware: state.settings.wallpaper.isTimeAware,
                            ),
                          ),
                        ));
                      }),
                ),
                Divider(
                  height: 0,
                ),
                ListTile(
                  title: Text("Show time in 24 Hours format"),
                  subtitle: Text("12 Hours format is used by default"),
                  trailing: Switch(
                      value: state.settings.timeFormat.is24Hours,
                      onChanged: (value) {
                        BlocProvider.of<SettingsBloc>(context)
                            .add(SetSettingsEvent(
                          SettingsModel(
                            unitSystem: UnitSystem(
                              isImperial: state.settings.unitSystem.isImperial,
                            ),
                            timeFormat: TimeFormat(
                              is24Hours: value,
                            ),
                            dataPreference: DataPreference(
                              isLocal: state.settings.dataPreference.isLocal,
                            ),
                            currentTheme: CurrentTheme(
                              isDark: state.settings.currentTheme.isDark,
                            ),
                            wallpaper: Wallpaper(
                              isTimeAware: state.settings.wallpaper.isTimeAware,
                            ),
                          ),
                        ));
                      }),
                ),
                Divider(
                  height: 0,
                ),
                ListTile(
                  title: Text("Show local data"),
                  subtitle: Text("Timezone aware data is used by default"),
                  trailing: Switch(
                      value: state.settings.dataPreference.isLocal,
                      onChanged: (value) {
                        BlocProvider.of<SettingsBloc>(context)
                            .add(SetSettingsEvent(
                          SettingsModel(
                            unitSystem: UnitSystem(
                              isImperial: state.settings.unitSystem.isImperial,
                            ),
                            timeFormat: TimeFormat(
                              is24Hours: state.settings.timeFormat.is24Hours,
                            ),
                            dataPreference: DataPreference(
                              isLocal: value,
                            ),
                            currentTheme: CurrentTheme(
                              isDark: state.settings.currentTheme.isDark,
                            ),
                            wallpaper: Wallpaper(
                              isTimeAware: state.settings.wallpaper.isTimeAware,
                            ),
                          ),
                        ));
                      }),
                ),
                Divider(
                  height: 0,
                ),
                ListTile(
                  title: Text("Use Dark Mode"),
                  subtitle: Text("Light Mode is used by default"),
                  trailing: Switch(
                      value: state.settings.currentTheme.isDark,
                      onChanged: (value) {
                        BlocProvider.of<SettingsBloc>(context)
                            .add(SetSettingsEvent(
                          SettingsModel(
                            unitSystem: UnitSystem(
                              isImperial: state.settings.unitSystem.isImperial,
                            ),
                            timeFormat: TimeFormat(
                              is24Hours: state.settings.timeFormat.is24Hours,
                            ),
                            dataPreference: DataPreference(
                              isLocal: state.settings.dataPreference.isLocal,
                            ),
                            currentTheme: CurrentTheme(
                              isDark: value,
                            ),
                            wallpaper: Wallpaper(
                              isTimeAware: state.settings.wallpaper.isTimeAware,
                            ),
                          ),
                        ));
                      }),
                ),
                Divider(
                  height: 0,
                ),
                ListTile(
                  title: Text("Show time aware wallpapers"),
                  subtitle: Text("Enabled by default"),
                  trailing: Switch(
                    value: state.settings.wallpaper.isTimeAware,
                    onChanged: (value) {
                      BlocProvider.of<SettingsBloc>(context)
                          .add(SetSettingsEvent(
                        SettingsModel(
                          unitSystem: UnitSystem(
                            isImperial: state.settings.unitSystem.isImperial,
                          ),
                          timeFormat: TimeFormat(
                            is24Hours: state.settings.timeFormat.is24Hours,
                          ),
                          dataPreference: DataPreference(
                            isLocal: state.settings.dataPreference.isLocal,
                          ),
                          currentTheme: CurrentTheme(
                            isDark: state.settings.currentTheme.isDark,
                          ),
                          wallpaper: Wallpaper(
                            isTimeAware: value,
                          ),
                        ),
                      ));
                    },
                  ),
                ),
                Divider(
                  height: 0,
                ),
                ListTile(
                  title: Text("About"),
                  subtitle: Text("About the app and the developer"),
                  onTap: () => showAboutDialog(
                    applicationName: "Weader",
                    applicationVersion: "1.0.0",
                    context: context,
                  ),
                ),
              ],
            ),
          );
        else if (state is SettingsError)
          return Scaffold(
            appBar: AppBar(
              title: Text("Settings"),
            ),
            body: ErrorDisplay(message: state.message),
          );
        return Container();
      },
    );
  }
}
