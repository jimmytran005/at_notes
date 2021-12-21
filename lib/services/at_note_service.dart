import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_commons/at_commons.dart';
import 'package:at_notes/model/NoteModel.dart';
import 'package:uuid/uuid.dart';
import 'package:at_notes/utils/constants.dart' as constants;

// This class implements all of the methods used for the backend operations
class AtNoteService {
  // Function to save the notes into the database
  Future<bool> saveNote(NoteModel note) async {
    AtKey atKey = AtKey();

    // Set the AtKey properties
    atKey.key = note.id;
    atKey.sharedWith = getUserAtSign();
    atKey.sharedBy = getUserAtSign();

    // Set the value string
    String value = note.title +
        constants.App.splitter +
        note.body +
        constants.App.splitter +
        note.creation_date.toString();

    // PUT operation to save the key pair value into the database
    // The .put() function returns a boolean indicating if it has successfully saved the data into database
    bool successPut =
        await AtClientManager.getInstance().atClient.put(atKey, value);

    return successPut;
  }

  // Function to retrieve the notes from the database
  // Return - a list of NoteModels
  Future<List<NoteModel>> retriveNotes() async {
    // Get all the keys from secondary server
    List<AtKey> allKeys;
    allKeys = await AtClientManager.getInstance()
        .atClient
        .getAtKeys(regex: constants.App.appNamespace);

    // List of NoteModels that is retrieved
    List<NoteModel> retrievedNotes = <NoteModel>[];

    // We will loop through the keys and continiously lookup the value based on atKey
    for (int i = 0; i < allKeys.length; i++) {
      // Get sharedby and sharedwith for current note`
      String currentSharedBy = allKeys[i].sharedBy!;
      String currentSharedWith = allKeys[i].sharedWith!;

      // Filter out the notes that belong to this user
      if (currentSharedWith == getUserAtSign() &&
          currentSharedBy == formatAtsign(getUserAtSign())) {
        var retrievedNote = await getOneNote(allKeys[i]);
        var noteContent = retrievedNote.value.split(constants.App.splitter);
        var note = NoteModel(
            id: allKeys[i].key!,
            title: noteContent[0],
            body: noteContent[1],
            creation_date: DateTime.parse(noteContent[2]),
            sharedWith: allKeys[i].sharedWith!,
            sharedBy: allKeys[i].sharedBy!,
            isShared: false);
        retrievedNotes.add(note);
      }
    }
    return retrievedNotes;
  }

  // Function to delete the note based on the atKey
  // Wil return a Future<bool> that will determine if the deletion was a success or not
  Future<bool> deleteNote(AtKey atKey, [bool isShared = false]) async {
    // If it is a shared note, then we want to just delete that note
    if (isShared) {
      return await AtClientManager.getInstance().atClient.delete(atKey);
    } else {
      try {
        // Delete all notes that are shared with users
        List<AtKey> allKeys;
        allKeys = await AtClientManager.getInstance()
            .atClient
            .getAtKeys(regex: constants.App.appNamespace); //, sharedBy: );

        for (int i = 0; i < allKeys.length; i++) {
          if (allKeys[i].key == atKey.key) {
            await AtClientManager.getInstance().atClient.delete(allKeys[i]);
          }
        }
        return true;
      } catch (e) {
        return false;
      }
    }
  }

  Future<List<NoteModel>> retrieveSharedNotes() async {
    // Get all the keys from secondary server
    List<AtKey> allKeys;

    allKeys = await AtClientManager.getInstance()
        .atClient
        .getAtKeys(regex: constants.App.appNamespace);

    // List of NoteModels that is retrieved
    List<NoteModel> retrievedNotes = <NoteModel>[];

    // We will loop through the keys and continiously lookup the value based on atKey
    for (int i = 0; i < allKeys.length; i++) {
      // Only add the entry to the list if the namespace is correct
      String? atSignFormatted = formatAtsign(
          AtClientManager.getInstance().atClient.getCurrentAtSign());
      String? atSignSharedWith = formatAtsign(allKeys[i].sharedWith);

      if (atSignFormatted! == atSignSharedWith!) {
        continue;
      }

      var retrievedNote = await getOneNote(allKeys[i]);
      var noteContent = retrievedNote.value.split(constants.App.splitter);
      var note = NoteModel(
          id: allKeys[i].key!,
          title: noteContent[0],
          body: noteContent[1],
          creation_date: DateTime.parse(noteContent[2]),
          sharedWith: allKeys[i].sharedWith!,
          sharedBy: allKeys[i].sharedBy!,
          isShared: true);
      retrievedNotes.add(note);
    }

    return retrievedNotes;
  }

  // GET look up the value based on the atKey
  Future<AtValue> getOneNote(AtKey atKey) async {
    return AtClientManager.getInstance().atClient.get(atKey);
  }

  // Function to get the current user's AtSign
  String getUserAtSign() {
    String? atSign = AtClientManager.getInstance().atClient.getCurrentAtSign();

    return atSign!;
  }

  // Function to generate time based uuid to uniquely identify a note
  String generateTimeBasedUUID() {
    return const Uuid().v1();
  }

  // Function to share a note with someone - NOT DONE
  Future<bool> shareNote(NoteModel note, String sharedWith) async {
    try {
      String? atSign =
          AtClientManager.getInstance().atClient.getCurrentAtSign();

      // Prepare AtKey for look up
      AtKey lookup = AtKey()
        ..key = note.id
        ..sharedWith = atSign
        ..sharedBy = atSign!.replaceAll("@", "")
        ..namespace = constants.App.appNamespace;

      // Lookup note and get the value of it
      String value =
          (await AtClientManager.getInstance().atClient.get(lookup)).value;

      // Prepare AtKey to save for this specific note
      Metadata metadata = Metadata()..ttr = 1;

      AtKey atKey = AtKey()
        ..key = note.id
        ..metadata = metadata
        ..sharedBy = atSign
        ..sharedWith = sharedWith;
      bool isSuccess =
          await AtClientManager.getInstance().atClient.put(atKey, value);
      return isSuccess;
    } catch (e) {
      return false;
    }
  }

  String? formatAtsign(String? atSign) {
    return atSign?.trim().replaceFirst("@", "");
  }

  Future<List<AtKey>> _getSharedKeys() async {
    return AtClientManager.getInstance()
        .atClient
        .getAtKeys(regex: 'cached.*notes');
  }

  // Function used to get all of the notes shared to this user
  // Will return a list of NoteModel instances
  Future<List<NoteModel>> getSharedNotes() async {
    List<NoteModel> listOfSharedNotes = <NoteModel>[];

    Map<String?, String> recipesMap = <String?, String>{};

    List<AtKey> sharedKeysList = await _getSharedKeys();

    AtKey atKey = AtKey();

    Metadata metadata = Metadata()..isCached = true;

    for (AtKey element in sharedKeysList) {
      atKey
        ..key = element.key
        ..sharedWith = element.sharedWith
        ..sharedBy = element.sharedBy
        ..metadata = metadata;

      String? response =
          (await AtClientManager.getInstance().atClient.get(atKey)).value;

      var noteContent = response!.split(constants.App.splitter);
      NoteModel sharedNote = NoteModel(
          id: element.key!,
          title: noteContent[0],
          body: noteContent[1],
          creation_date: DateTime.parse(noteContent[2]),
          sharedWith: element.sharedWith!,
          sharedBy: element.sharedBy!,
          isShared: true);

      listOfSharedNotes.add(sharedNote);
    }

    return listOfSharedNotes;
  }
}
