import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_client/src/service/notification_service.dart';
import 'package:at_commons/at_commons.dart';
import 'package:at_notes/model/NoteModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:at_notes/utils/constants.dart' as constants;

// This class implements all of the methods used for the backend operations
class AtNoteService {
  static final String? atSign =
      AtClientManager.getInstance().atClient.getCurrentAtSign();

  // Function to save the notes into the database
  Future<bool> saveNote(NoteModel note) async {
    AtKey atKey = AtKey();

    // Set the AtKey properties
    atKey.key = note.id;
    atKey.sharedWith = getUserAtSign();

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
        //.getAtKeys(regex:'cached.*notes');
        .getAtKeys(regex: constants.App.appNamespace);//, sharedBy: );
    // List of NoteModels that is retrieved
    List<NoteModel> retrievedNotes = <NoteModel>[];

    // We will loop through the keys and continiously lookup the value based on atKey
    for (int i = 0; i < allKeys.length; i++) {
      // Only add the entry to the list if the namespace is correct
      if (allKeys[i].namespace == constants.App.appNamespace) {


        if(allKeys[i].sharedBy == atSign){continue;}

        var retrievedNote = await getOneNote(allKeys[i]);
        var noteContent = retrievedNote.value.split(constants.App.splitter);
        var note = NoteModel(
            id: allKeys[i].key!,
            title: noteContent[0],
            body: noteContent[1],
            creation_date: DateTime.parse(noteContent[2]));
        retrievedNotes.add(note);
      }
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

  // Function to generate time based uuid to uniquely identify a note
  String generateTimeBasedUUID() {
    return const Uuid().v1();
  }

  // Function to delete all notes -- FOR DEBUGGING/DEVELOPMENT USE ONLY
  Future<void> clearAllNotes() async {
    List<AtKey> allKeys;
    allKeys = await AtClientManager.getInstance()
        .atClient
        .getAtKeys(regex: constants.App.appNamespace);

    for (int i = 0; i < allKeys.length; i++) {
      await deleteNote(allKeys[i]);
    }
  }

  // Function to share a note with someone - NOT DONE
  Future<bool> shareNote(NoteModel note, String sharedWith) async {
    String? atSign = AtClientManager.getInstance().atClient.getCurrentAtSign();

    // Prepare AtKey for look up
    AtKey lookup = AtKey()
      ..key = note.id
      ..sharedWith = atSign;

    // Lookup note and get the value of it
    String value =
        (await AtClientManager.getInstance().atClient.get(lookup)).value;


    // Prepare AtKey to save for this specific note
    AtKey atKey = AtKey()
      ..key = note.id
      ..sharedBy = atSign
      ..sharedWith = sharedWith;
    //bool isSuccess =
    // await AtClientManager.getInstance().atClient.put(atKey, value);
    // return isSuccess;

    try{
      await AtClientManager.getInstance().notificationService.notify(
        NotificationParams.forUpdate(
          atKey,
          value: value,
        ),
      );
      return true;
    } on AtClientException catch (e) {
      print('AtClientException : ${e.errorCode} - ${e.errorMessage}');
      return false;
    } catch (e) {
      print('Exception : $e');
      return false;
    }

  }

  // Need functions to shareNote(), retrieveSharedNotes()
}
