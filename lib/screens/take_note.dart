import 'package:flutter/material.dart';

class TakenoteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('my note'),
        elevation:4.0,
        actions:[
          TextButton(
            child: Text('Done', style: TextStyle(color: Colors.white)),
            onPressed: () {  },
          ),
        ],
        leading:
        IconButton(
          icon: Icon(Icons.add_box),
          onPressed: () {  },
        ),

      ),
      body: Text('This is the note taking screen'),
    );
  }
}
