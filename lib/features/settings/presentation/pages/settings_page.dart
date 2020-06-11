import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/entities/settings.dart';
import '../../../../core/widgets/widgets.dart';
import '../bloc/bloc.dart';
import '../widgets/settings_list_view.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  SettingsBloc bloc;
  Settings settings;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<SettingsBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state is SettingsLoaded) {
          settings = state.settings;

          return _returnScaffoldWithSettingsListView();
        } else if (state is SettingsError) {
          if (settings != null) return _returnScaffoldWithSettingsListView();
          return Scaffold(
            appBar: _appBar(),
            body: Container(),
          );
        }
        return Scaffold(
          appBar: _appBar(),
          body: LoadingDisplay(),
        );
      },
    );
  }

  Scaffold _returnScaffoldWithSettingsListView() {
    return Scaffold(
      appBar: AppBar(
        leading: SmallIconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back),
        ),
        title: Text("Settings"),
      ),
      body: SettingsListView(
        settings: settings,
        bloc: bloc,
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text("Settings"),
    );
  }
}
