import 'package:at_notes/model/NoteModel.dart';
import 'package:at_notes/service/client_sdk_service.dart';
import 'package:at_notes/service/at_note_service.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'package:at_notes/constants.dart' as constant;
import 'package:flutter/cupertino.dart';
import 'package:at_commons/at_commons.dart';
import 'package:at_client_mobile/at_client_mobile.dart';

class AddNote extends StatefulWidget {
  Note? note;

  AddNote({@required this.note});

  @override
  _AddNoteState createState() => _AddNoteState();

}

class _AddNoteState extends State<AddNote> {
  //_AddNoteState({@required this.note});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AtKey noteKey = AtKey();
  AtNoteService service = new AtNoteService();


  String? title;
  String body = "???";
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

                 service.saveNote(new NoteModel(title: title!, body: body, creation_date: date!));
                 //_update(context);
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
              TextButton(
                onPressed: _lookupData,
                child: Text('Look up data'),
              ),
              Text(body)
       ],),
     ),
   );
  }




  Future<void> _update(BuildContext context) async{
    ClientSdkService clientSdkService = ClientSdkService.getInstance();
    String? atSign = clientSdkService.atsign;

    FormState? form = _formKey.currentState;

    if(title!= null && body != null){
      //service.saveNote(noteKey, NoteModel(title: title!, body: body!, creation_date: date!));

      String _values = body + constant.splitter + date!.toString();
      AtKey pair = AtKey();
      pair.key = title;
      pair.sharedWith = atSign;
      bool isPut = await clientSdkService.put(pair, _values);
      /*
      isPut ? Navigator.pop(context)
            : ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Failed to put data',
                    textAlign: TextAlign.center,
                  ),
                ),
      );*/

    }

  }

  void setData(String data) {
    print('inside setData $data');
    setState(() {
      body = data;
    });
  }

  void _lookupData() async {
    String lookupKey = titleController.text;
    AtKey atKey = AtKey();
    atKey.key = lookupKey;

    // lookups the specifc value, based on the key
    //dynamic val = await _lookup(atKey);

    dynamic val = await service.getOneNote(atKey);
    
   // setData((val.value == null) ? 'No Value Associated with key' : val.value);
    setData((val == null) ? 'No Value Associated with key' : val.value);
  }

  Future<dynamic> _lookup(AtKey atKey) async {
    if (atKey != null) {
     // return AtClientManager.getInstance().atClient.get(atKey);
      return ClientSdkService.getInstance().get(atKey);
    }
    return null;
  }

  void saveNote(NoteModel note) async {
    AtKey atkey = AtKey();
    // Set the AtKey properties
    atkey.key = note.title;
    atkey.sharedWith = AtClientManager.getInstance().atClient.getCurrentAtSign();
    // Set the value›
    String value = note.body + "@_@" + note.creation_date.toString();

    // PUT operation to save the key pair value into the database
    // The .put() function returns a boolean indicating if it has successfully saved the data into database
    bool successPut =
    await AtClientManager.getInstance().atClient.put(atkey, value);
    successPut? "Add data successfully" : "fail to add data.";
  }

}
