import 'package:at_notes/services/at_note_service.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'package:at_notes/model/NoteModel.dart';
import 'package:at_notes/components/note.dart';
import 'package:at_commons/at_commons.dart';

// This is the screen to add/share/delete a note
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

  TextEditingController sharedWithController = TextEditingController();

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
              icon: Icon(Icons.send_to_mobile),
              onPressed: () async {
                // This is a modal that will pop up to prompt the user if they want to share their notes with someone
                // REFERENCE: https://api.flutter.dev/flutter/material/showModalBottomSheet.html
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: 200,
                      color: Colors.white,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Text(
                              'Enter the @sign you want to share',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.blueGrey,
                              ),
                            ),
                            TextField(
                              textAlign: TextAlign.center,
                              controller: sharedWithController,
                              autofocus: true,
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: ElevatedButton(
                                        child: const Text('Cancel'),
                                        onPressed: () => Navigator.pop(context),
                                      )),
                                  Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: ElevatedButton(
                                          child: const Text('Share'),
                                          onPressed: () async {
                                            // noteService.shareNote(note, sharedWithController.text)
                                            print(widget.note!.title);

                                            if (widget.note != null &&
                                                sharedWithController.text !=
                                                    '') {
                                              String userToShareWith =
                                                  sharedWithController.text;
                                              Note savedNote = widget.note!;
                                              NoteModel noteModel = NoteModel(
                                                  id: savedNote.id!,
                                                  title: savedNote.title!,
                                                  body: savedNote.description!,
                                                  creation_date: DateTime.parse(
                                                      savedNote.date!),
                                                  sharedWith:
                                                      widget.note!.sharedWith!,
                                                  sharedBy:
                                                      widget.note!.sharedBy!,
                                                  isShared: false);
                                              bool isSuccess =
                                                  await noteService.shareNote(
                                                      noteModel,
                                                      userToShareWith);

                                              if (isSuccess) {
                                                _showToast(context,
                                                    'Sucessfully shared with $userToShareWith');
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const HomeScreen()));
                                              } else {
                                                _showToast(context,
                                                    '@sign @$userToShareWith does not exist!');
                                                Navigator.pop(context);
                                              }
                                            } else {
                                              print(
                                                  'CANNOT SHARE this note until saved');
                                            }
                                          }))
                                ])
                          ],
                        ),
                      ),
                    );
                  },
                );
                // noteService.shareNote(note, sharedWith)
                // await noteService.clearAllNotes();
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                // await noteService.clearAllNotes();
                AtKey atKey = AtKey();
                atKey.sharedWith = widget.note!.sharedWith!;
                atKey.key = widget.note!.id;
                bool isSuccess = await noteService.deleteNote(atKey);
                if (isSuccess) {
                  _showToast(context, 'Sucessfully deleted note!');
                  // Navigator.pop(context);

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
                      creation_date: date!,
                      sharedWith: (widget.note == null)
                          ? noteService.getUserAtSign()
                          : widget.note!.sharedWith!,
                      sharedBy: (widget.note == null)
                          ? noteService.getUserAtSign()
                          : widget.note!.sharedBy!,
                      isShared: false);

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

  // This is a function to show a toast once a task is done
  void _showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
            label: 'DONE', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
