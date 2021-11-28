import 'package:at_notes/constants.dart';
import 'package:at_notes/service/client_sdk_service.dart';
import 'package:flutter/material.dart';
import 'package:at_notes/screens/add_note.dart';
import 'package:at_commons/at_commons.dart';
import 'package:at_notes/constants.dart' as constant;
import 'package:at_notes/service/at_note_service.dart';
import 'package:at_notes/model/NoteModel.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AtNoteService service = new AtNoteService();


    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      // SingleChildScrollView : REFERENCE : https://api.flutter.dev/flutter/widgets/SingleChildScrollView-class.html
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              Expanded(
                  child: FutureBuilder<List<NoteModel>>(
                    //future: _scan(),
                    future: service.retriveNotes(),
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      print("data: ");
                      print(snapshot.data);
                      if(snapshot.data == null){
                        return Container(
                          child: Center(
                            child:Text("Loading...")
                          )
                        );
                      } else {
                          return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                title: Text(snapshot.data[index].title),
                              );
                            },
                          );
                      }
                    }/*{
                      if (snapshot.hasData) {
                        List<String> noteAttributes = snapshot.data;
                        print("Printing data: ");
                        print(noteAttributes);
                        List<NoteModel> notes = <NoteModel>[];
                        for(String attribute in noteAttributes){
                          List<String> attributesList = attribute.split(constant.splitter);
                          if(attributesList.length >= 3) {
                            Note note = Note(
                                attributesList[0],
                                attributesList[1],
                                attributesList[2],
                                false
                            );
                            notes.add(note);
                          }
                        }
                        return SafeArea(
                          child: ListView(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                                  const Text(
                                    'My Notes',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 32,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ]),
                              ),
                              Column(
                                children: notes,
                              ),
                            ],
                          ),
                        );
                      } else if(snapshot.hasError) {
                        return Text('An error has occured: '+snapshot.error.toString());
                      } else {
                        print("else statement?");
                        return const Center(child: CircularProgressIndicator());
                      }
                    },*/
                  )),
            ],
          ),
        ),
      ),

      /*
      SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Note(
                  't1',
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt',
                  'Feb 10, 2020',
                  false),
              Note(
                  't2',
                  'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit',
                  'Feb 10, 2020',
                  false)
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Note(
                  't3',
                  'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit',
                  'Feb 10, 2020',
                  true),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Note(
                  't4',
                  'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit.',
                  'Feb 10, 2020',
                  false),
              Note(
                  't5',
                  'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip.',
                  'Feb 10, 2020',
                  false)
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Note(
                  't6',
                  'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit.',
                  'Feb 10, 2020',
                  false),
              Note(
                  't7',
                  'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip.',
                  'Feb 10, 2020',
                  false)
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Note(
                  't8',
                  'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit.',
                  'Feb 10, 2020',
                  false),
              Note(
                  't9',
                  'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip.',
                  'Feb 10, 2020',
                  false)
            ]),
          ],
        ),
      ),*/
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/note');
          },
          child: const Icon(Icons.add)),
    );
  }

  Future<List<String>> _scan() async {
    ClientSdkService clientSdkService = ClientSdkService.getInstance();
    String? atSign = clientSdkService.atsign;
    List<AtKey> response;
    response = await clientSdkService.getAtKeys(regex);
    response.retainWhere((AtKey element) => !element.metadata!.isCached);
    //response = await clientSdkService.getAtKeys(regex,sharedBy: atSign);

    List<String> responseList = <String>[];
    print("responseList: " + responseList.toString());
    for(AtKey atKey in response){
      String? value = await _lookup(atKey);

      value = atKey.key! + constant.splitter + value!;

      responseList.add(value);
      print("Add value " + value + "\n");
    }

    return responseList;
  }

  Future<dynamic> _lookup(AtKey? atKey) async {
    ClientSdkService clientSdkService = ClientSdkService.getInstance();
    if(atKey != null)
      return clientSdkService.get(atKey);
    return null;
  }


}

// This will be the note component that will be displayed on the home screen
// ignore: must_be_immutable
class Note extends StatelessWidget {
  // properties of the note
  String? title;
  String? description;
  String? date;
  bool? isExpanded;

  Note(this.title, this.description, this.date, this.isExpanded, {Key? key})
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
              Navigator.push(context,
              MaterialPageRoute<dynamic>(builder: (BuildContext context) {
                return AddNote(note: this);
              }))
            },
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
                            Text(title!,
                                style:
                                const TextStyle(color: descriptionColor)),
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

