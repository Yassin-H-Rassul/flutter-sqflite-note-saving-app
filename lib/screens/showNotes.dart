import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sql_proj/note_model.dart';
import 'package:sql_proj/note_provider.dart';
import 'package:sql_proj/screens/updateNotes.dart';

class ShowNotes extends StatefulWidget {
  const ShowNotes({Key? key}) : super(key: key);

  @override
  _ShowNotesState createState() => _ShowNotesState();
}

class _ShowNotesState extends State<ShowNotes> {
  checkForRebuilding() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
          child: FutureBuilder<List<Note>>(
        future: Provider.of<NoteProvider>(context, listen: false).fetchNotes(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return ListView.separated(
            itemCount: snapshot.data!.length,
            separatorBuilder: (context, index) {
              return Divider();
            },
            itemBuilder: (context, index) {
              return NoteTile(
                  note: snapshot.data![index],
                  rebuildHandler: checkForRebuilding);
            },
          );
        },
      )),
    );
  }
}

class NoteTile extends StatelessWidget {
  final Note note;
  final VoidCallback rebuildHandler;
  const NoteTile({
    Key? key,
    required this.note,
    required this.rebuildHandler,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              updateNotes(note: note, rebuildHandler: rebuildHandler),
        ),
      ),
      child: Dismissible(
        onDismissed: (direction) {
          Provider.of<NoteProvider>(context, listen: false).delete(note.id!);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('the note: ${note.noteContent} deleted'),
            ),
          );
        },
        background: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            child: Center(
              child: Text(
                "delete",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            color: Colors.red.shade400,
          ),
        ),
        key: Key(note.toString()),
        child: Container(
          padding: EdgeInsets.all(30),
          color: Colors.blue,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(note.noteContent),
              Text(note.selectedDate),
            ],
          ),
        ),
      ),
    );
  }
}
