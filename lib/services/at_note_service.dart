import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_commons/at_commons.dart';

// This class will impl the methods to
class AtNoteService {
  String atSign;

  AtNoteService(this.atSign);

  // This function will save the notes into the database
  void saveNote(AtKey noteKey, String noteContent) async {
    AtKey atKey = AtKey();

    // set the key
    atKey.key = noteContent;

    // PUT operation to save the key pair value into the database
    // The .put() function returns a boolean indicating if it has successfully saved the data into database
    bool successPut =
        await AtClientManager.getInstance().atClient.put(atKey, noteContent);
  }

  // GET look up the value based on the key
  Future<dynamic> getNotes(AtKey atKey) async {
    if (atKey != null) {
      return AtClientManager.getInstance().atClient.get(atKey);
    }
    return null;
  }
}
