import 'package:at_notes/model/NoteModel.dart';
import 'package:flutter/material.dart';
import 'package:at_notes/components/note.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Widget listOfNotes() {
    List<NoteModel> notesList = <NoteModel>[];
    notesList.add(NoteModel(
        title: 'Yo this is a Note 1',
        body: 'This is the content 1',
        creation_date: DateTime.now()));
    notesList.add(NoteModel(
        title: 'Yo this is a Note 2',
        body: 'This is the content 2',
        creation_date: DateTime.now()));
    notesList.add(NoteModel(
        title: 'Yo this is a Note 3',
        body: 'This is the content 3',
        creation_date: DateTime.now()));
    notesList.add(NoteModel(
        title: 'Yo this is a Note 4',
        body: 'This is the content 4',
        creation_date: DateTime.now()));
    notesList.add(NoteModel(
        title: 'Yo this is a Note 5',
        body: 'This is the content 5',
        creation_date: DateTime.now()));
    notesList.add(NoteModel(
        title: 'Yo this is a Note 6',
        body: 'This is the content 6',
        creation_date: DateTime.now()));

    List<Widget> listsOfRow = <Widget>[];

    for (int i = 0; i < notesList.length; i += 2) {
      var row =
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Note(notesList[i].title, notesList[i].body,
            notesList[i].creation_date.toString(), false),
        Note(notesList[i + 1].title, notesList[i + 1].body,
            notesList[i + 1].creation_date.toString(), false)
      ]);

      listsOfRow.add(row);
    }
    return Column(children: listsOfRow);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      // SingleChildScrollView : REFERENCE : https://api.flutter.dev/flutter/widgets/SingleChildScrollView-class.html
      body: SingleChildScrollView(child: listOfNotes()),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/note');
          },
          child: const Icon(Icons.add)),
    );
  }
}
