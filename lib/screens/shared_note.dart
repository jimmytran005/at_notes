import 'package:at_notes/components/note.dart';
import 'package:at_notes/model/NoteModel.dart';
import 'package:at_notes/services/at_note_service.dart';
import 'package:flutter/material.dart';
import 'package:at_commons/at_commons.dart';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_notes/utils/constants.dart' as constants;
import 'package:at_notes/services/at_note_service.dart';

// class SharedPage extends StatelessWidget {

//   final String? atSign = AtNoteService().getUserAtSign();
//   @override
//   Widget build(BuildContext context) => Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Shared Notes'
//         ),
//       ),
//       body:SingleChildScrollView(

//       ),
//   );

/*
  Future<List<AtKey>> _getSharedKeys() async {

    return await AtClientManager.getInstance()
          .atClient
          .getAtKeys('cached.*');
  }

  Future<Map<String?, String>> _getSharedNotes() async {

    List<AtKey> sharedKyesList = await _getSharedKeys();

  }*/
// }

class SharedPage extends StatelessWidget {
  const SharedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shared notes'),
      ),
      // SingleChildScrollView : REFERENCE : https://api.flutter.dev/flutter/widgets/SingleChildScrollView-class.html

      body: SingleChildScrollView(
          child: FutureBuilder<List<NoteModel>>(
        future: _scan(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            List<NoteModel> notesList = snapshot.data;

            List<Widget> listsOfRow = <Widget>[];
            for (int i = 0; i < notesList.length; i++) {
              List<Widget> rowChildren = <Widget>[];

              rowChildren.add(Note(
                  notesList[i].id,
                  notesList[i].title,
                  notesList[i].body,
                  notesList[i].creation_date.toString(),
                  notesList[i].sharedWith,
                  true,
                  true));

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
    List<NoteModel> listOfNotes = await atNoteService.retrieveSharedNotes();
    return listOfNotes;
  }
}
