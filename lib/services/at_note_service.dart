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
    print('Atclient ' + getUserAtSign());
    // Get all the keys from secondary server
    List<AtKey> allKeys;
    allKeys = await AtClientManager.getInstance()
        .atClient
        .getAtKeys(regex: constants.App.appNamespace); //, sharedBy: );

    //.getAtKeys(regex:'cached.*notes');
    // List of NoteModels that is retrieved
    List<NoteModel> retrievedNotes = <NoteModel>[];

    // We will loop through the keys and continiously lookup the value based on atKey
    for (int i = 0; i < allKeys.length; i++) {
      print("THE KEY " + allKeys[i].toString());
      // Only add the entry to the list if the namespace is correct
      String? atSignFormatted = formatAtsign(
          AtClientManager.getInstance().atClient.getCurrentAtSign());
      String? atSignSharedWith = formatAtsign(allKeys[i].sharedWith);

      if (atSignFormatted! != atSignSharedWith!) {
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
          isShared: false);
      retrievedNotes.add(note);
    }

    print('retrievedNotes ' + retrievedNotes.toString());
    return retrievedNotes;
  }

  // Function to delete the note based on the atKey
  // Wil return a Future<bool> that will determine if the deletion was a success or not
  Future<bool> deleteNote(AtKey atKey, [bool isShared = false]) async {
    print("deleteNote atkey:" +
        atKey.toString() +
        " isShared:" +
        isShared.toString());
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
            print("KEYS ARE EQUAL");
            await AtClientManager.getInstance().atClient.delete(allKeys[i]);
          }
        }
        return true;
      } catch (e) {
        return false;
      }
    }
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
    try {
      String? atSign =
          AtClientManager.getInstance().atClient.getCurrentAtSign();

      // Prepare AtKey for look up
      AtKey lookup = AtKey()
        ..key = note.id
        ..sharedWith = atSign
        ..sharedBy = atSign!.replaceAll("@", "")
        ..namespace = constants.App.appNamespace;

      print(lookup);

      // Lookup note and get the value of it
      String value =
          (await AtClientManager.getInstance().atClient.get(lookup)).value;

      // Prepare AtKey to save for this specific note
      AtKey atKey = AtKey()
        ..key = note.id
        ..sharedBy = atSign
        ..sharedWith = sharedWith;
      bool isSuccess =
          await AtClientManager.getInstance().atClient.put(atKey, value);
      return isSuccess;
    } catch (e) {
      return false;
    }

/*
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
*/
  }

  String? formatAtsign(String? atSign) {
    return atSign?.trim().replaceFirst("@", "");
  }

  Future<List<NoteModel>> retrieveSharedNotes() async {
    print('Atclient ' + getUserAtSign());
    // Get all the keys from secondary server
    List<AtKey> allKeys;
    allKeys = await AtClientManager.getInstance()
        .atClient
        .getAtKeys(regex: constants.App.appNamespace);

    // List of NoteModels that is retrieved
    List<NoteModel> retrievedNotes = <NoteModel>[];

    // We will loop through the keys and continiously lookup the value based on atKey
    print("\n");
    for (int i = 0; i < allKeys.length; i++) {
      print("THE KEY FROM SHARED RETRIEVAL " + allKeys[i].toString());
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
          isShared: true);
      retrievedNotes.add(note);
    }

    return retrievedNotes;
  }

  // Need functions retrievedNotesSharedToMe()
}
