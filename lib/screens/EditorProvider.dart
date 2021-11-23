import 'package:flutter/material.dart';
import 'Text_Field.dart';

class EditorProvider extends ChangeNotifier {
  List<FocusNode> _nodes = [];
  List<TextEditingController> _text = [];
  List<SmartTextType> _types = [];
  SmartTextType selectedType = SmartTextType.T;


  EditorProvider({SmartTextType defaultType = SmartTextType.T}){
    selectedType = defaultType;
    insert(index: 0);
  }

  int get length => _text.length;
  int get focus => _nodes.indexWhere((node)=>node.hasFocus);
  FocusNode nodeAt(int index) => _nodes.elementAt(index);
  TextEditingController textAt(int index) => _text.elementAt(index);
  SmartTextType typeAt(int index) => _types.elementAt(index);


  void setType(SmartTextType type) {
    if (selectedType == type) {
      selectedType = SmartTextType.T;
    }
    else {
      selectedType = type;
    }
    _types.removeAt(focus);
    _types.insert(focus, selectedType);
    notifyListeners();
  }

  void setFocus(SmartTextType type){
    selectedType = type;
    notifyListeners();
  }

  void insert({int? index, String? text, SmartTextType type = SmartTextType.T}) {
    final TextEditingController controller = TextEditingController(
        text: text?? ''
    );


    }
  }

