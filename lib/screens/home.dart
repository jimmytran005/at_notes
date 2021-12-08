import 'package:at_notes/model/NoteModel.dart';
import 'package:at_notes/services/at_note_service.dart';
import 'package:flutter/material.dart';
import 'package:at_notes/components/note.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home'), automaticallyImplyLeading: false),
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

              String convertDateTime = "${notesList[i].creation_date.year.toString()}"
                  "-${notesList[i].creation_date.month.toString().padLeft(2,'0')}"
                  "-${notesList[i].creation_date.day.toString().padLeft(2,'0')} "
                  "${notesList[i].creation_date.hour.toString().padLeft(2,'0')}"
                  ":${notesList[i].creation_date.minute.toString().padLeft(2,'0')}";

              rowChildren.add(Note(
                  notesList[i].id,
                  notesList[i].title,
                  notesList[i].body,
                  convertTime(notesList[i].creation_date),
                  ((i + 1) == notesList.length) ? true : false));

              // If the next index exists
              if ((i + 1) < notesList.length) {
                rowChildren.add(Note(
                    notesList[i + 1].id,
                    notesList[i + 1].title,
                    notesList[i + 1].body,
                    //notesList[i + 1].creation_date.toString(),
                    convertTime(notesList[i+1].creation_date),
                    false));
              }

              var row = Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: rowChildren);

              // Add the row to the listOfRows
              listsOfRow.add(row);
            }
            return Column(children: listsOfRow);


          } else if (snapshot.hasError) {
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

  String convertTime(DateTime now){

    return "${now.year.toString()}"
        "-${now.month.toString().padLeft(2,'0')}"
        "-${now.day.toString().padLeft(2,'0')} ${now.hour.toString().padLeft(2,'0')}"
        ":${now.minute.toString().padLeft(2,'0')}";
  }
}
