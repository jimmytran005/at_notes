import 'package:flutter/material.dart';

enum SmartTextType { H1, T, QUOTE, BULLET }

// This is the text field component that is used within the widget where we are writing the note
extension SmartTextStyle on SmartTextType {
  TextStyle get textStyle {
    switch (this) {
      case SmartTextType.QUOTE:
        return TextStyle(
            fontSize: 16.0, fontStyle: FontStyle.italic, color: Colors.white70);
      case SmartTextType.H1:
        return TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold);

      default:
        return TextStyle(fontSize: 16.0);
    }
  }

  EdgeInsets get padding {
    switch (this) {
      case SmartTextType.H1:
        return EdgeInsets.fromLTRB(16, 24, 16, 8);
      case SmartTextType.BULLET:
        return EdgeInsets.fromLTRB(24, 8, 16, 8);
      default:
        return EdgeInsets.fromLTRB(16, 8, 16, 8);
    }
  }

  TextAlign get align {
    switch (this) {
      case SmartTextType.QUOTE:
        return TextAlign.center;
      default:
        return TextAlign.start;
    }
  }

  String get prefix {
    switch (this) {
      case SmartTextType.BULLET:
        return '\u2022';
      default:
        return '';
    }
  }
}

class SmartTextField extends StatelessWidget {
  final SmartTextType type;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  const SmartTextField(
      {Key? key, required this.type, this.controller, this.focusNode})
      : super(key: key);

  Widget build(BuildContext context) {
    return TextField(
        controller: controller,
        focusNode: focusNode,
        autofocus: true,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        cursorColor: Colors.teal,
        textAlign: type.align,
        decoration: InputDecoration(
            border: InputBorder.none,
            prefixText: type.prefix,
            prefixStyle: type.textStyle,
            isDense: true,
            contentPadding: type.padding),
        style: type.textStyle);
  }
}
