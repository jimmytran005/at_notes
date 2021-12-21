import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'Text_Field.dart';

// This is the keyboard tool bar component
class KeyBoardToolbar extends StatelessWidget {
  const KeyBoardToolbar(
      {Key? key, required this.onSelected, required this.selectedType})
      : super(key: key);

  final SmartTextType selectedType;
  final ValueChanged<SmartTextType> onSelected;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(56),
      child: Material(
          elevation: 4.0,
          color: Colors.white,
          child: Row(children: <Widget>[
            IconButton(
                icon: Icon(CommunityMaterialIcons.format_size,
                    color: selectedType == SmartTextType.H1
                        ? Colors.teal
                        : Colors.black),
                onPressed: () => onSelected(SmartTextType.H1)),
            IconButton(
                icon: Icon(CommunityMaterialIcons.format_quote_open,
                    color: selectedType == SmartTextType.QUOTE
                        ? Colors.teal
                        : Colors.black),
                onPressed: () => onSelected(SmartTextType.QUOTE)),
            IconButton(
                icon: Icon(CommunityMaterialIcons.format_list_bulleted,
                    color: selectedType == SmartTextType.BULLET
                        ? Colors.teal
                        : Colors.black),
                onPressed: () => onSelected(SmartTextType.BULLET))
          ])),
    );
  }
}
