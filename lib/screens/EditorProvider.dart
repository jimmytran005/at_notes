import 'package:flutter/material.dart';
import 'Text_Field.dart';

class EditorProvider extends ChangeNotifier {

  SmartTextType selectedType;

  EditorProvider({SmartTextType defaultType = SmartTextType.T})
      : selectedType = defaultType;

  void setType(SmartTextType type) {
    if (selectedType == type) {
      selectedType = SmartTextType.T;
    }
    else {
      selectedType = type;
    }
    notifyListeners();
  }

}