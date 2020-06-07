import 'package:flutter/material.dart';
import 'package:weader/features/locations/presentation/pages/search_page.dart';
import 'package:weader/features/settings/presentation/pages/settings_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weader"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SearchPage(),
                  ),
                );
              }),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          "You've not saved any location yet!",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
