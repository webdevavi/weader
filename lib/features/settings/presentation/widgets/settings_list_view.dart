import 'package:Weader/core/app_info/app_info.dart';
import 'package:Weader/core/snack_bar/show_snack_bar.dart';
import 'package:Weader/injector.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import '../../../../core/entities/entities.dart';
import '../bloc/bloc.dart';

class SettingsListView extends StatelessWidget {
  final Settings settings;
  final SettingsBloc bloc;

  SettingsListView({
    Key key,
    @required this.settings,
    @required this.bloc,
  }) : super(key: key);

  final AppInfo getInfo = getIt<AppInfo>();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text("Show units in Imperial Unit System"),
          subtitle: Text("Metric Unit System is used by default"),
          trailing: Switch(
            value: settings.unitSystem.isImperial,
            onChanged: (value) => _switchUnitSystem(value, context),
          ),
        ),
        Divider(
          height: 0,
        ),
        ListTile(
          title: Text("Show time in 24 Hours format"),
          subtitle: Text("12 Hours format is used by default"),
          trailing: Switch(
            value: settings.timeFormat.is24Hours,
            onChanged: (value) => _switchTimeFormat(value, context),
          ),
        ),
        Divider(
          height: 0,
        ),
        ListTile(
          title: Text("Show local data"),
          subtitle: Text("Timezone aware data is used by default"),
          trailing: Switch(
            value: settings.dataPreference.isLocal,
            onChanged: (value) => _switchDataPreference(value, context),
          ),
        ),
        Divider(
          height: 0,
        ),
        ListTile(
          title: Text("Use Dark Mode"),
          subtitle: Text("Light Mode is used by default"),
          trailing: Switch(
            value: settings.currentTheme.isDark,
            onChanged: (value) => _switchCurrentTheme(value, context),
          ),
        ),
        Divider(
          height: 0,
        ),
        ListTile(
          title: Text("Show time aware wallpapers"),
          subtitle: Text("Enabled by default"),
          trailing: Switch(
            value: settings.wallpaper.isTimeAware,
            onChanged: (value) => _switchWallpaper(value, context),
          ),
        ),
        Divider(
          height: 0,
        ),
        ListTile(
          title: Text("About"),
          subtitle: Text("About the app and the developer"),
          onTap: () => _showAboutDialog(context),
        ),
      ],
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      applicationIcon: Image.asset(
        'assets/logo.png',
        width: 34,
        height: 34,
      ),
      applicationName: getInfo.appName.substring(0, 1).toUpperCase() +
          getInfo.appName.substring(1),
      applicationVersion: getInfo.version,
      children: <Widget>[
        Text('App ID: ${getInfo.packageName}'),
        Text('Build Number: ${getInfo.buildNumber}'),
      ],
      context: context,
    );
  }

  void _switchUnitSystem(
    bool value,
    BuildContext context,
  ) {
    bloc.add(
      SwitchUnitSystemEvent(UnitSystem(isImperial: value)),
    );

    _showSnackBar(
      label: "Unit System",
      value: value,
      ifTrue: "Imperial",
      ifFalse: "Metric",
      context: context,
    );
  }

  void _switchTimeFormat(
    bool value,
    BuildContext context,
  ) {
    bloc.add(
      SwitchTimeFormatEvent(TimeFormat(is24Hours: value)),
    );
    _showSnackBar(
      label: "Time Format",
      value: value,
      ifTrue: "24 Hours",
      ifFalse: "12 Hours",
      context: context,
    );
  }

  void _switchDataPreference(
    bool value,
    BuildContext context,
  ) {
    bloc.add(
      SwitchDataPreferenceEvent(DataPreference(isLocal: value)),
    );
    _showSnackBar(
      label: "Data Preference",
      value: value,
      ifTrue: "Local",
      ifFalse: "Timezone Aware",
      context: context,
    );
  }

  void _switchCurrentTheme(
    bool value,
    BuildContext context,
  ) {
    bloc.add(
      SwitchCurrentThemeEvent(CurrentTheme(isDark: value)),
    );

    String text = value ? "Dark" : "Light";

    Color color = value ? Colors.grey.shade900 : Colors.deepOrange;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Flushbar(
        backgroundColor: color,
        message: "Current theme set to $text",
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(8.0),
        borderRadius: 6.0,
        dismissDirection: FlushbarDismissDirection.HORIZONTAL,
        forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      )..show(context);
    });
  }

  void _switchWallpaper(bool value, BuildContext context) {
    bloc.add(
      SwitchWallpaperEvent(Wallpaper(isTimeAware: value)),
    );
    _showSnackBar(
      label: "Wallpaper",
      value: value,
      ifTrue: "Time Aware Wallpapers",
      ifFalse: "Solid Background",
      context: context,
    );
  }

  void _showSnackBar({
    String label = "",
    @required bool value,
    @required String ifTrue,
    @required String ifFalse,
    @required BuildContext context,
  }) {
    String _text;
    if (value == true)
      _text = ifTrue;
    else
      _text = ifFalse;

    String text = "$label set to $_text";

    showSnackBar(context: context, message: text);
  }
}
