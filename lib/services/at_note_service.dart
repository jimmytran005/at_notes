import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_commons/at_commons.dart';
import 'package:at_notes/model/NoteModel.dart';

// This class implements all of the methods used for the backend operations
class AtNoteService {
  static final String? atSign =
      AtClientManager.getInstance().atClient.getCurrentAtSign();

  static const String splitter = '@_@';

  // Function to save the notes into the database
  void saveNote(AtKey noteKey, NoteModel note) async {
    AtKey atKey = AtKey();

    // Set the AtKey properties
    atKey.key = note.title;
    atKey.sharedWith = atSign;

    // Set the value
    String value = note.body + splitter + note.creation_date.toString();

    // PUT operation to save the key pair value into the database
    // The .put() function returns a boolean indicating if it has successfully saved the data into database
    bool successPut =
        await AtClientManager.getInstance().atClient.put(atKey, value);
  }

  // Function to retrieve the notes from the database
  // Return - a list of NoteModels
  Future<List<NoteModel>> retriveNotes() async {
    // Get all the keys from secondary server
    List<AtKey> allKeys;
    allKeys = await AtClientManager.getInstance().atClient.getAtKeys();

    // List of NoteModels that is retrieved
    List<NoteModel> retrievedNotes = <NoteModel>[];

    // We will loop through the keys and continiously lookup the value based on atKey
    for (int i = 0; i < allKeys.length; i++) {
      var retrievedNote = getOneNote(allKeys[i]);
      var noteContent = retrievedNote.toString().split(splitter);
      var note = NoteModel(
          title: allKeys[i].key!,
          body: noteContent[0],
          creation_date: DateTime.parse(noteContent[1]));
      retrievedNotes.add(note);
    }

    return retrievedNotes;
  }

  // Function to delete the note based on the atKey
  // Wil return a Future<bool> that will determine if the deletion was a success or not
  Future<bool> deleteNote(AtKey atKey) async {
    return await AtClientManager.getInstance().atClient.delete(atKey);
  }

  // GET look up the value based on the atKey
  Future<AtValue> getOneNote(AtKey atKey) async {
    return AtClientManager.getInstance().atClient.get(atKey);
  }

  // Function to get the current user's AtSign
  String getUserAtSign() {
    return atSign!;
  }
}
