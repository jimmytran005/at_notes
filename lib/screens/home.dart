import 'package:flutter/material.dart';
import 'package:at_notes/components/note.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      // SingleChildScrollView : REFERENCE : https://api.flutter.dev/flutter/widgets/SingleChildScrollView-class.html
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Note(
                  't1',
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do e',
                  'Feb 10, 2020',
                  false),
              Note(
                  't2',
                  'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui',
                  'Feb 10, 2020',
                  false)
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Note(
                  't3',
                  'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit',
                  'Feb 10, 2020',
                  true),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Note(
                  't4',
                  'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui ',
                  'Feb 10, 2020',
                  false),
              Note(
                  't5',
                  'Ut enim ad minim veniam, quis nostrud exercitation ullamco lab',
                  'Feb 10, 2020',
                  false)
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Note(
                  't6',
                  'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui of',
                  'Feb 10, 2020',
                  false),
              Note(
                  't7',
                  'Ut enim ad minim veniam, quis nostrud exercitation ullamco la',
                  'Feb 10, 2020',
                  false)
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Note(
                  't8',
                  'Excepteur sint occaecat cupidatat non proident, sunt in culpa',
                  'Feb 10, 2020',
                  false),
              Note(
                  't9',
                  'Ut enim ad minim veniam, quis nostrud exercitation ullamco la.',
                  'Feb 10, 2020',
                  false)
            ]),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/note');
          },
          child: const Icon(Icons.add)),
    );
  }
}
