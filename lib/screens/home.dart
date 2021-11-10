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
  final AtClientManager atClientInstance = AtClientManager.getInstance();

  final _textController = TextEditingController();

  // this will get the at client instance to do database operations
  AtClient? _getAtClientForAtsign() => atClientInstance.atClient;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: _textController,
        ),
        TextButton(
          onPressed: _doPerformSaveToDatabase,
          child: Text('Save Content'),
        ),
        TextButton(
          onPressed: _clearFields,
          child: Text('Clear Content'),
        )
      ],
    );
  }

  void _clearFields() {
    _textController.text = '';
  }

  void _doPerformSaveToDatabase() {
    String content = _textController.text;
    print('content: $content');
  }

  /// Creates or updates [AtKey.key] with it's
  /// [AtValue.value] and returns Future bool value.
  Future<bool> put(AtKey atKey, String value) async {
    try {
      return _getAtClientForAtsign()!.put(atKey, value);
    } on AtClientException catch (atClientExcep) {
      _logger.severe('❌ AtClientException : ${atClientExcep.errorMessage}');
      return false;
    } catch (e) {
      _logger.severe('❌ Exception : ${e.toString()}');
      return false;
    }
  }
}
