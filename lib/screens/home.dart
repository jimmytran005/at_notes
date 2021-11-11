import 'package:flutter/material.dart';
import 'package:at_commons/at_commons.dart';
import 'package:at_client_mobile/at_client_mobile.dart';

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
  // data retrieved variable
  String _dataValue = '';

  // controllers for the two input fields
  final _keyController = TextEditingController();
  final _valueController = TextEditingController();

  void setData(String data) {
    print('inside setData $data');
    setState(() {
      _dataValue = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration.collapsed(hintText: 'Key'),
          controller: _keyController,
        ),
        TextFormField(
          decoration: InputDecoration.collapsed(hintText: 'Value'),
          controller: _valueController,
        ),
        TextButton(
          onPressed: _doPerformSaveToDatabase,
          child: Text('Save data'),
        ),
        TextButton(
          onPressed: _lookupData,
          child: Text('Look up data'),
        ),
        Text(_dataValue)
      ],
    );
  }

// This function will look up the data based on the key
  void _lookupData() async {
    String lookupKey = _keyController.text;
    AtKey atKey = AtKey();
    atKey.key = lookupKey;

    // lookups the specifc value, based on the key
    dynamic val = await _lookup(atKey);
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

    // PUT operation to save the key pair value into the database
    // The .put() function returns a boolean indicating if it has successfully saved the data into database
    bool successPut =
        await AtClientManager.getInstance().atClient.put(atKey, theValue);

    // Check if the opaeration is successful
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
  Future<dynamic> _lookup(AtKey atKey) async {
    if (atKey != null) {
      return AtClientManager.getInstance().atClient.get(atKey);
    }
    return null;
  }
}
