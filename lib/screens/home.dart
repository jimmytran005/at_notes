import 'package:flutter/material.dart';
import 'package:at_notes/screens/add_note.dart';

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
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt',
                  'Feb 10, 2020',
                  false),
              Note(
                  't2',
                  'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit',
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
                  'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit.',
                  'Feb 10, 2020',
                  false),
              Note(
                  't5',
                  'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip.',
                  'Feb 10, 2020',
                  false)
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Note(
                  't6',
                  'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit.',
                  'Feb 10, 2020',
                  false),
              Note(
                  't7',
                  'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip.',
                  'Feb 10, 2020',
                  false)
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Note(
                  't8',
                  'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit.',
                  'Feb 10, 2020',
                  false),
              Note(
                  't9',
                  'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip.',
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

// This will be the note component that will be displayed on the home screen
// ignore: must_be_immutable
class Note extends StatelessWidget {
  // properties of the note
  String? title;
  String? description;
  String? date;
  bool? isExpanded;

  Note(this.title, this.description, this.date, this.isExpanded, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double widthOfScreen = MediaQuery.of(context).size.width;
    double heightOfScreen = MediaQuery.of(context).size.height;

    const dateColor = Color(0xff8F8F8F);
    const descriptionColor = Colors.black;
    const backgroundColor = Color(0xffD2D2D2);

    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: GestureDetector(
            onTap: () => {
              Navigator.push(context,
              MaterialPageRoute<dynamic>(builder: (BuildContext context) {
                return AddNote(note: this);
              }))
            },
            child: SizedBox(
              width: widthOfScreen / (isExpanded! ? 1.1 : 2.4),
              height: heightOfScreen / 5,
              child: Card(
                  color: backgroundColor,
                  child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(title!,
                                style:
                                const TextStyle(color: descriptionColor)),
                            Text(description!,
                                style:
                                    const TextStyle(color: descriptionColor)),
                            SizedBox(
                                width: MediaQuery.of(context)
                                    .size
                                    .width, // will make the size of the sizedBox to be 100% of the parent component
                                child: Text(date!,
                                    style: const TextStyle(color: dateColor)))
                          ]))),
            )));
  }
}

