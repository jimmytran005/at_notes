import 'package:flutter/material.dart';
import 'package:at_notes/screens/add_note.dart';

// This will be the note component that will be displayed on the home screen
// ignore: must_be_immutable
class Note extends StatelessWidget {
  // properties of the note
  String? id;
  String? title;
  String? description;
  String? date;
  bool? isExpanded;

  Note(this.id, this.title, this.description, this.date, this.isExpanded,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double widthOfScreen = MediaQuery.of(context).size.width;
    double heightOfScreen = MediaQuery.of(context).size.height;

    const dateColor = Color(0xff8F8F8F);
    const descriptionColor = Colors.black;
    const backgroundColor = Color(0xffD2D2D2);

    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: GestureDetector(
            onTap: () => {
                  Navigator.push(context, MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) {
                    return AddNote(note: this);
                  }))
                },
            child: SizedBox(
              width: widthOfScreen / (isExpanded! ? 1.1 : 2.4),
              height: heightOfScreen / 5,
              child: Card(
                  //color: backgroundColor,
                  color: Colors.grey[300],
                  child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                          children: [
                            Text(title!,
                                style:
                                    const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,color: descriptionColor)),
                            Text(description!,
                                style:
                                    const TextStyle(color: descriptionColor)),
                            SizedBox(
                                width: MediaQuery.of(context)
                                    .size
                                    .width, // will make the size of the sizedBox to be 100% of the parent component
                                child: Text(date!,
                                    style: const TextStyle(color: dateColor)))
                          ]))),
            )));
  }
}
