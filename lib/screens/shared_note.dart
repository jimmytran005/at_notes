import 'package:at_notes/services/at_note_service.dart';
import 'package:flutter/material.dart';
import 'package:at_notes/model/NoteModel.dart';
import 'package:at_notes/components/note.dart';
import 'package:at_commons/at_commons.dart';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_notes/utils/constants.dart' as constants;
import 'package:at_notes/services/at_note_service.dart';


class SharedPage extends StatelessWidget {

  final String? atSign = AtNoteService().getUserAtSign();
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text(
          'Shared Notes'
        ),
      ),
      body:SingleChildScrollView(
        child: FutureBuilder<List<NoteModel>>(
        future: _scanShared(),
        builder:(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.hasData){
            List<NoteModel> notesList = snapshot.data;
            List<Widget> listsOfRow = <Widget>[];
            for (int i = 0; i < notesList.length; i += 2) {
              List<Widget> rowChildren = <Widget>[];

              rowChildren.add(Note(
                  notesList[i].id,
                  notesList[i].title,
                  notesList[i].body,
                  notesList[i].creation_date.toString(),
                  ((i + 1) == notesList.length) ? true : false));

              // If the next index exists
              if ((i + 1) < notesList.length) {
                rowChildren.add(Note(
                    notesList[i + 1].id,
                    notesList[i + 1].title,
                    notesList[i + 1].body,
                    notesList[i + 1].creation_date.toString(),
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
            return Text('Error with getting shared notes');
          } else {
            return Text('No Notes');
          }
        },
        ),
      ),
  );

  Future<List<NoteModel>> _scanShared() async {
    AtNoteService atNoteService = AtNoteService();
    List<NoteModel> listOfNotes = await atNoteService.retrieveSharedNotes();
    return listOfNotes;
  }

}