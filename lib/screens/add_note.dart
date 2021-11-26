import 'package:at_notes/service/client_sdk_service.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'package:at_notes/constants.dart' as constant;
import 'package:flutter/cupertino.dart';
import 'package:at_commons/at_commons.dart';

class AddNote extends StatefulWidget {
  Note? note;

  AddNote({@required this.note});

  @override
  _AddNoteState createState() => _AddNoteState();

}

class _AddNoteState extends State<AddNote> {
  //_AddNoteState({@required this.note});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? title;
  String? body;
  DateTime? date;

  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    if(widget.note!=null){
      titleController = TextEditingController(text: widget.note!.title.toString());
      bodyController = TextEditingController(text: widget.note!.description.toString());
    }

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
                 setState((){
                   title = titleController.text;
                   body = bodyController.text;
                   date = DateTime.now();
                 });
                 _update(context);
                 /*
                 Navigator.push(
                   context,
                   MaterialPageRoute(builder: (context) => const HomeScreen()),
                 ); */
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

  Future<void> _update(BuildContext context) async{
    ClientSdkService clientSdkService = ClientSdkService.getInstance();
    String? atSign = clientSdkService.atsign;

    FormState? form = _formKey.currentState;
    if(title!= null && body != null){
      String _values = body! + constant.splitter + date!.toString();
      AtKey pair = AtKey();
      pair.key = title;
      pair.sharedWith = atSign;
      bool isPut = await clientSdkService.put(pair, _values);
      isPut ? Navigator.pop(context)
            : ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Failed to put data',
                    textAlign: TextAlign.center,
                  ),
                ),
      );
    }



    /*
    if(form!.validate()){
      String _values = body! + constant.splitter + date!.toString();
      AtKey atKey = AtKey();
      atKey.key = title;
      atKey.sharedWith = atSign;

      bool successPut = await clientSdkService.put(atKey, _values);

      successPut ? Navigator.pop(context)
          : ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '           Failed to put data',
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
        print('Not all text fields have been completed!');
    }*/

  }



}
