import 'package:flutter/material.dart';
import 'TextEditor.dart';
import 'home.dart';

class TakenoteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon:Icon(Icons.menu),
              onPressed: () { },
            ),
            IconButton(
              icon:Icon(Icons.send_to_mobile),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {  },
            ),
          ],
        ),
        //title: Text(widget.title),
        elevation:4.0,
        actions:<Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextButton(
                child: Text('Done', style: TextStyle(color: Colors.black)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
                style: TextButton.styleFrom(backgroundColor: Colors.white,)
            ),
          ),
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: TextEditor(),
      ),
    );
  }
}
