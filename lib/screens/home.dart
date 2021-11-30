import 'package:at_notes/model/NoteModel.dart';
import 'package:at_notes/services/at_note_service.dart';
import 'package:flutter/material.dart';
import 'package:at_notes/components/note.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  // Widget listOfNotes() async {
  //   AtNoteService noteService = AtNoteService();
  //   List<NoteModel> notesList = await noteService.retriveNotes();
  //   // notesList.add(NoteModel(
  //   //     title: 'Yo this is a Note 1',
  //   //     body: 'This is the content 1',
  //   //     creation_date: DateTime.now()));

  //   // notesList.add(NoteModel(
  //   //     title: 'Yo this is a Note 1',
  //   //     body: 'This is the content 1',
  //   //     creation_date: DateTime.now()));

  //   // notesList.add(NoteModel(
  //   //     title: 'Yo this is a Note 1',
  //   //     body: 'This is the content 1',
  //   //     creation_date: DateTime.now()));

  //   List<Widget> listsOfRow = <Widget>[];

  //   for (int i = 0; i < notesList.length; i += 2) {
  //     List<Widget> rowChildren = <Widget>[];

  //     rowChildren.add(Note(
  //         notesList[i].title,
  //         notesList[i].body,
  //         notesList[i].creation_date.toString(),
  //         ((i + 1) == notesList.length) ? true : false));

  //     // If the next index exists
  //     if ((i + 1) < notesList.length) {
  //       rowChildren.add(Note(notesList[i].title, notesList[i + 1].body,
  //           notesList[i + 1].creation_date.toString(), false));
  //     }

  //     var row = Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //         children: rowChildren);

  //     // Add the row to the listOfRows
  //     listsOfRow.add(row);
  //   }
  //   return Column(children: listsOfRow);
  // }

  @override
  Widget build(BuildContext context) {
    AtNoteService atNoteService = AtNoteService();

    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      // SingleChildScrollView : REFERENCE : https://api.flutter.dev/flutter/widgets/SingleChildScrollView-class.html
      body: SingleChildScrollView(
          child: FutureBuilder<List<NoteModel>>(
        future: _scan(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            List<NoteModel> notesList = snapshot.data;

            List<Widget> listsOfRow = <Widget>[];
            for (int i = 0; i < notesList.length; i += 2) {
              List<Widget> rowChildren = <Widget>[];

              rowChildren.add(Note(
                  notesList[i].title,
                  notesList[i].body,
                  notesList[i].creation_date.toString(),
                  ((i + 1) == notesList.length) ? true : false));

              // If the next index exists
              if ((i + 1) < notesList.length) {
                rowChildren.add(Note(notesList[i].title, notesList[i + 1].body,
                    notesList[i + 1].creation_date.toString(), false));
              }

              var row = Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: rowChildren);

              // Add the row to the listOfRows
              listsOfRow.add(row);
            }
            return Column(children: listsOfRow);
          } else if (snapshot.hasError) {
            print(snapshot.data);
            return Text('Error');
          } else {
            return Text('No Notes');
          }
        },
      )),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Navigator.pushNamed(context, '/note');
          },
          child: const Icon(Icons.add)),
    );
  }

  Future<List<NoteModel>> _scan() async {
    AtNoteService atNoteService = AtNoteService();
    List<NoteModel> listOfNotes = await atNoteService.retriveNotes();
    return listOfNotes;
  }
}
