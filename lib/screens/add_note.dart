import 'package:flutter/material.dart';
import 'home.dart';
class AddNote extends StatefulWidget {
  AddNote({Key? key}) : super(key: key);

  @override
  _AddNoteState createState() => _AddNoteState();

}

class _AddNoteState extends State<AddNote> {
  String? title;
  String? body;
  DateTime? date;

  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();


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
               child: Text('save', style: TextStyle(color: Colors.black)),
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
     body: Padding(
       padding: const EdgeInsets.symmetric(vertical:8.0,horizontal:12.0),
       child: Column(
         children:[
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Title',
                ),
                style: TextStyle(fontSize: 28.0,fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: TextField(
                  controller: bodyController,
                  keyboardType: TextInputType.multiline,
                  maxLines:null,
                  decoration:InputDecoration(
                    border: InputBorder.none,
                    hintText: "note...",
                  ),
                ),
              ),
       ],),
     ),
   );
  }
}
