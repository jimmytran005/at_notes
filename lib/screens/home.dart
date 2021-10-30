import 'package:flutter/material.dart';
import 'package:at_notes/components/note.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        TextButton.styleFrom(primary: Theme.of(context).colorScheme.onPrimary);
    return Scaffold(
        appBar: AppBar(title: Text('Home page'), actions: <Widget>[
          TextButton(
            style: style,
            onPressed: () {},
            child: const Text('Home'),
          ),
          TextButton(
            style: style,
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
            child: const Text('Settings'),
          )
        ]),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Note('Note 1', 'This is Note 1'),
            Note('Note 2', 'This is Note 2'),
            Note('Note 3', 'This is Note 3'),
          ],
        ));
  }
}
