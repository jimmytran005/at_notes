import 'package:at_app_flutter/at_app_flutter.dart';
import 'package:at_notes/model/NoteModel.dart';
import 'package:at_notes/services/at_note_service.dart';
import 'package:flutter/material.dart';
import 'package:at_commons/at_commons.dart';
import 'package:at_client_mobile/at_client_mobile.dart';
import '../utils/constants.dart' as constants;

class HomeScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: InputField(),
    );
  }
}

// ignore: use_key_in_widget_constructors
class InputField extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  AtNoteService noteService = AtNoteService();

  // data retrieved variable
  String _dataValue = '';
  List<NoteModel>? _allData;

  // controllers for the two input fields
  final _keyController = TextEditingController();
  final _valueController = TextEditingController();

  void setData(String data) {
    print('inside setData $data');
    setState(() {
      _dataValue = data;
    });
  }

  void setAllData(List<NoteModel> _listOfAllData) {
    setState(() {
      _allData = _listOfAllData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration.collapsed(
              hintText: 'Key (title) - Enter Key to save or to look up'),
          controller: _keyController,
        ),
        TextFormField(
          decoration:
              const InputDecoration.collapsed(hintText: 'Value (content)'),
          controller: _valueController,
        ),
        TextButton(
          onPressed: _doPerformSaveToDatabase,
          child: const Text('Save data'),
        ),
        TextButton(
          onPressed: _lookupData,
          child: const Text('Look up data'),
        ),
        TextButton(
          onPressed: deleteAllDataFromDataBase,
          child: const Text('Clear database'),
        ),
        TextButton(
          onPressed: _getAllDataFromDatabase,
          child: const Text('Get All Notes'),
        ),
        Text(_dataValue),
        const SizedBox(
          height: 10,
        ),
        Text("LIST OF NOTES: " + _allData.toString())
      ],
    );
  }

  void _getAllDataFromDatabase() async {
    print("THE ENV " + AtEnv.appNamespace);
    List<NoteModel> _listOfAllData = await noteService.retriveNotes();
    setAllData(_listOfAllData);
  }

// This function will look up the data based on the key
  void _lookupData() async {
    String lookupKey = _keyController.text;
    AtKey atKey = AtKey();

    atKey.key = lookupKey;
    atKey.sharedWith = noteService.getUserAtSign();

    // lookups the specifc value, based  on the key
    AtValue val = await _lookup(atKey);
    setData((val.value == null) ? 'No Value Associated with key' : val.value);
  }

  // this will save the contents to the secondary server
  Future<void> _doPerformSaveToDatabase() async {
    AtKey atKey = AtKey();
    // get the key and value from the input field
    String theKey = _keyController.text;
    String theValue = _valueController.text;

    // set the key
    atKey.key = theKey;
    atKey.sharedWith = noteService.getUserAtSign();
    atKey.namespace = 'at_notes';

    var successPut = await noteService.saveNote(atKey,
        NoteModel(_keyController.text, _valueController.text, DateTime.now()));

    if (successPut) {
      setData('sucessfully saved onto database {' +
          atKey.key! +
          ':"' +
          theValue +
          '"}');
      print('sucessfully saved onto database');
    } else {
      setData('failed to saved!');
      print('failed to saved!');
    }
  }

  // GET look up the value based on the key
  Future<AtValue> _lookup(AtKey atKey) async {
    print('The atKey we are trying to search...' + atKey.toString());
    return await noteService.getOneNote(atKey);
  }

  void deleteAllDataFromDataBase() async {
    List<AtKey> allKeys;
    allKeys = await AtClientManager.getInstance()
        .atClient
        .getAtKeys(regex: constants.App.appNamespace);
    // We will loop through the keys and continiously lookup the value based on atKey
    for (int i = 0; i < allKeys.length; i++) {
      await AtClientManager.getInstance().atClient.delete(allKeys[i]);
    }
  }
}
