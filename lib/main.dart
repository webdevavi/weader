import 'package:flutter/material.dart';

import 'features/locations/presentation/pages/locations_pages.dart';
import 'injector.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weader',
      theme: ThemeData(
        primaryColor: Colors.deepOrange,
        primaryColorDark: Colors.deepOrange.shade800,
        accentColor: Colors.teal,
      ),
      home: SearchPage(),
    );
  }
}
