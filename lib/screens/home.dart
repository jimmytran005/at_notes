import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Note(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt',
                'Feb 10, 2020',
                false),
            Note(
                'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit',
                'Feb 10, 2020',
                false)
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Note(
                'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit',
                'Feb 10, 2020',
                true),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Note(
                'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit.',
                'Feb 10, 2020',
                false),
            Note(
                'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip.',
                'Feb 10, 2020',
                false)
          ]),
        ],
      ),
    );
  }
}

// This will be the note component that will be displayed on the home screen
// ignore: must_be_immutable
class Note extends StatelessWidget {
  // properties of the note
  String? description;
  String? date;
  bool? isExpanded;

  Note(this.description, this.date, this.isExpanded, {Key? key})
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
        child: SizedBox(
          width: widthOfScreen / (isExpanded! ? 1.1 : 2.4),
          height: heightOfScreen / 5,
          child: Card(
              color: backgroundColor,
              child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(description!,
                            style: const TextStyle(color: descriptionColor)),
                        Text(date!, style: const TextStyle(color: dateColor))
                      ]))),
        ));
  }
}
