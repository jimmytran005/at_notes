import 'package:at_notes/services/at_note_service.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'package:at_notes/model/NoteModel.dart';
import 'package:at_notes/components/note.dart';
import 'package:at_commons/at_commons.dart';

class AddNote extends StatefulWidget {
  Note? note;

  AddNote({@required this.note});

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  Note? note;
  AtNoteService noteService = AtNoteService();
  //_AddNoteState({@required this.note});

  String? title;
  String? body;
  DateTime? date;

  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.note != null) {
      titleController =
          TextEditingController(text: widget.note!.title.toString());
      bodyController =
          TextEditingController(text: widget.note!.description.toString());
    }

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.send_to_mobile),
              onPressed: () async {
                // await noteService.clearAllNotes();
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                // await noteService.clearAllNotes();
                AtKey atKey = AtKey();
                atKey.sharedWith = noteService.getUserAtSign();
                atKey.key = widget.note!.id;
                bool isSuccess = await noteService.deleteNote(atKey);
                if (isSuccess) {
                  _showToast(context, 'Sucessfully deleted note!');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()));
                } else {
                  _showToast(context, 'Failed to delete note!');
                }
              },
            ),
          ],
        ),
        //title: Text(widget.title),
        elevation: 4.0,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextButton(
                child:
                    const Text('save', style: TextStyle(color: Colors.black)),
                onPressed: () async {
                  setState(() {
                    title = titleController.text;
                    body = bodyController.text;
                    date = DateTime.now();
                  });

                  NoteModel noteToSave = NoteModel(
                      // If it's a preexisting note, get the id of that note, otherwise generate a new UUID for the new note
                      id: (widget.note == null)
                          ? noteService.generateTimeBasedUUID()
                          : widget.note!.id!,
                      title: title!,
                      body: body!,
                      creation_date: date!);

                  bool isSuccess = await noteService.saveNote(noteToSave);

                  if (isSuccess) {
                    _showToast(context, 'Sucessfully Saved note!');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                    );
                  } else {
                    _showToast(context, 'Failed to save note!');
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                )),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Title',
              ),
              style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: TextField(
                controller: bodyController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "note...",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
