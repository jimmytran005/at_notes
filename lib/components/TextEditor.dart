import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'EditorProvider.dart';
import 'KeyBoardToolBar.dart';
import 'Text_Field.dart';

// This is the text editor component that is used within the add notes screen
class TextEditor extends StatefulWidget {
  TextEditor({Key? key}) : super(key: key);

  @override
  _TextEditorState createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditorProvider>(
        create: (context) => EditorProvider(),
        builder: (context, child) {
          return SafeArea(
            child: Scaffold(
                body: Stack(
              children: <Widget>[
                Positioned(
                  top: 16,
                  left: 0,
                  right: 0,
                  bottom: 56,
                  child: Consumer<EditorProvider>(builder: (context, state, _) {
                    return SmartTextField(type: state.selectedType);
                  }),
                ),
                Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Selector<EditorProvider, SmartTextType>(
                      selector: (buildContext, state) => state.selectedType,
                      builder: (context, selectedType, _) {
                        return KeyBoardToolbar(
                          onSelected: Provider.of<EditorProvider>(context,
                                  listen: false)
                              .setType,
                          selectedType: selectedType,
                        );
                      },
                    ))
              ],
            )),
          );
        });
  }
}
