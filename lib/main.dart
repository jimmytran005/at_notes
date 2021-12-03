import 'dart:async';

import 'package:flutter/material.dart';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_onboarding_flutter/at_onboarding_flutter.dart'
    show Onboarding;
import 'package:at_utils/at_logger.dart' show AtSignLogger;
import 'package:path_provider/path_provider.dart'
    show getApplicationSupportDirectory;
import 'package:at_app_flutter/at_app_flutter.dart' show AtEnv;
import 'package:at_notes/utils/constants.dart' as constants;

// IMPORTS from screen
import 'package:at_notes/screens/home.dart';
import 'package:at_notes/screens/add_note.dart';

Future<void> main() async {
  await AtEnv.load();
  runApp(const MyApp());
}

Future<AtClientPreference> loadAtClientPreference() async {
  var dir = await getApplicationSupportDirectory();
  return AtClientPreference()
        ..rootDomain = constants.App.rootDomain
        ..namespace = constants.App.appNamespace
        ..hiveStoragePath = dir.path
        ..commitLogPath = dir.path
        ..isLocalStoreRequired = true
      // TODO set the rest of your AtClientPreference here
      ;
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // * load the AtClientPreference in the background
  Future<AtClientPreference> futurePreference = loadAtClientPreference();
  AtClientPreference? atClientPreference;

  final AtSignLogger _logger = AtSignLogger(AtEnv.appNamespace);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // * The onboarding screen (first screen)
      home: Scaffold(
        appBar: AppBar(
          title: const Text('MyApp'),
        ),
        body: Builder(
          builder: (context) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    var preference = await futurePreference;
                    setState(() {
                      atClientPreference = preference;
                    });
                    Onboarding(
                      context: context,
                      atClientPreference: atClientPreference!,
                      domain: AtEnv.rootDomain,
                      rootEnvironment: AtEnv.rootEnvironment,
                      appAPIKey: AtEnv.appApiKey,
                      onboard: (value, atsign) {
                        _logger.finer('Successfully onboarded $atsign');
                      },
                      onError: (error) {
                        _logger.severe('Onboarding throws $error error');
                      },
                      nextScreen: const MainWidget(),
                    );
                  },
                  child: const Text('Onboard an @sign'),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () async {
                  KeyChainManager _keyChainManager =
                      KeyChainManager.getInstance();
                  List<String>? _atSignsList =
                      await _keyChainManager.getAtSignListFromKeychain();
                  if (_atSignsList == null || _atSignsList.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          '@sign list is empty.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  } else {
                    for (String element in _atSignsList) {
                      await _keyChainManager.deleteAtSignFromKeychain(element);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Keychain cleaned',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                },
                child: const Text(
                  "Reset Keychain",
                  style: TextStyle(color: Colors.blueGrey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// This is the main widget that houses all of the screens routings
// REFERENCE: https://flutter.dev/docs/cookbook/navigation/named-routes
class MainWidget extends StatelessWidget {
  const MainWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Named Routes Demo',
      // Start the app with the "/" named route. In this case, the app starts
      // on the FirstScreen widget.
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the HomeScreen widget.
        '/': (context) => HomeScreen(),
        // When navigating to the "/note" route, build the TakenotesScreen widget.
        '/note': (context) => AddNote(),
      },
    );
  }
}
