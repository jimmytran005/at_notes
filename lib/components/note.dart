import 'package:flutter/material.dart';

// This class defines a component for a note
class Note extends StatelessWidget {
  // properties of Note
  String? title;
  String? content;

  // contructor that will take in the title and the content of this note
  Note(this.title, this.content, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Container(
          child: Text('title: ${title}  content: ${content}'),
          constraints: BoxConstraints(minWidth: width, minHeight: 100),
          color: Colors.green[200]),
    );
  }
}
