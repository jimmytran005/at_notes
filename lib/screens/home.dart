import 'package:at_notes/model/NoteModel.dart';
import 'package:at_notes/screens/shared_note.dart';
import 'package:at_notes/services/at_note_service.dart';
import 'package:flutter/material.dart';
import 'package:at_notes/components/note.dart';

// Home screen that shows all of the user's notes
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerWidget(),

      appBar: AppBar(
        title: Text('Home'),
      ),
      // SingleChildScrollView : REFERENCE : https://api.flutter.dev/flutter/widgets/SingleChildScrollView-class.html

      body: SingleChildScrollView(
          child: FutureBuilder<List<NoteModel>>(
        future: _scan(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            List<NoteModel> notesList = snapshot.data;

            List<Widget> listsOfRow = <Widget>[];
            for (int i = 0; i < notesList.length; i += 2) {
              List<Widget> rowChildren = <Widget>[];

              String convertDateTime =
                  "${notesList[i].creation_date.year.toString()}"
                  "-${notesList[i].creation_date.month.toString().padLeft(2, '0')}"
                  "-${notesList[i].creation_date.day.toString().padLeft(2, '0')} "
                  "${notesList[i].creation_date.hour.toString().padLeft(2, '0')}"
                  ":${notesList[i].creation_date.minute.toString().padLeft(2, '0')}";

              rowChildren.add(Note(
                  notesList[i].id,
                  notesList[i].title,
                  notesList[i].body,
                  convertTime(notesList[i].creation_date),
                  notesList[i].sharedWith,
                  notesList[i].sharedBy,
                  ((i + 1) == notesList.length) ? true : false,
                  false));

              // If the next index exists
              if ((i + 1) < notesList.length) {
                rowChildren.add(Note(
                    notesList[i + 1].id,
                    notesList[i + 1].title,
                    notesList[i + 1].body,
                    convertTime(notesList[i + 1].creation_date),
                    notesList[i + 1].sharedWith,
                    notesList[i + 1].sharedBy,
                    notesList[i + 1].isShared,
                    false));
              }
              var row = Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: rowChildren);

              // Add the row to the listOfRows
              listsOfRow.add(row);
            }
            return Column(children: listsOfRow);
          } else if (snapshot.hasError) {
            return Text('Error');
          } else {
            return Text('No Notes');
          }
        },
      )),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Navigator.pushNamed(context, '/note');
          },
          child: const Icon(Icons.add)),
    );
  }

  Future<List<NoteModel>> _scan() async {
    AtNoteService atNoteService = AtNoteService();
    List<NoteModel> listOfNotes = await atNoteService.retriveNotes();
    return listOfNotes;
  }

  String convertTime(DateTime now) {
    return "${now.year.toString()}"
        "-${now.month.toString().padLeft(2, '0')}"
        "-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}"
        ":${now.minute.toString().padLeft(2, '0')}";
  }
}

class NavigationDrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AtNoteService noteService = AtNoteService();
    String atSign = noteService.getUserAtSign();

    final padding = EdgeInsets.symmetric(horizontal: 20);
    // A drawer menu that has selections Shared Notes, Favoroutes, and Recent Deleted notes
    return Drawer(
        child: Material(
      color: Colors.blue,
      child: ListView(
        padding: padding,
        children: <Widget>[
          const SizedBox(height: 50),
          buildUserWelcome(
            text: 'Welcome, $atSign',
          ),
          buildMenuItem(
            text: 'Shared Notes',
            icon: Icons.people_alt_outlined,
            onClicked: () => selectedItem(context, 0),
          ),
          const SizedBox(height: 16),
          buildMenuItem(
            text: 'Favourites',
            icon: Icons.favorite_border,
          ),
          const SizedBox(height: 16),
          buildMenuItem(
            text: 'Recent Delete',
            icon: Icons.delete_forever_outlined,
          ),
        ],
      ),
    ));
  }

  // Function to build the widget menu for the drawer
  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.white70;
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(fontSize: 20, color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  // Function to build the user welcome message on the drawer
  Widget buildUserWelcome({
    required String text,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.white70;
    return ListTile(
      title: Text(text, style: TextStyle(fontSize: 15, color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  // Function to select an item on the drawer
  void selectedItem(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => SharedPage()));
        break;
    }
  }
}
