import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'screens/settings.dart';

// entry point function, will call the MyApp() to start the app
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Named Routes Demo',
      // Start the app with the "/" named route. In this case, the app starts
      // on the HomePage widget.
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the HomePage widget.
        '/': (context) => HomePage(),
        // When navigating to the "/second" route, build the SettingsPage widget.
        '/settings': (context) => SettingsPage(),
      },
    );
  }
}
