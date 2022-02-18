import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sql_proj/note_model.dart';
import 'package:sql_proj/note_provider.dart';
import 'package:sql_proj/screens/showNotes.dart';

class addNewNote extends StatefulWidget {
  const addNewNote({Key? key}) : super(key: key);

  @override
  _addNewNoteState createState() => _addNewNoteState();
}

class _addNewNoteState extends State<addNewNote> {
  TextEditingController _noteController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Get a location using getDatabasesPath

    initializeDb();
  }

  initializeDb() async {
    print('initializing db.....................');
    const _databaseName = "notes.db";
    final documentDirectory = await getApplicationDocumentsDirectory();
    final path = Path.join(documentDirectory.path, _databaseName);
    Provider.of<NoteProvider>(context, listen: false).open(path);
    print('initializiation done111111111111111111');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: _noteController,
            ),
            Text(
              _selectedDate == null
                  ? 'No Date Chosen!'
                  : 'Date chosen: ${DateFormat.yMd().format(_selectedDate!)}',
            ),
            ElevatedButton(
              child: Text('choose date'),
              onPressed: _presentDataPicker,
            ),
            ElevatedButton(
              onPressed: () {
                Note _note = Note(
                    noteContent: _noteController.text,
                    selectedDate: _selectedDate!.toIso8601String());
                Provider.of<NoteProvider>(context, listen: false).insert(_note);
              },
              child: Text('add new note'),
            ),
            SizedBox(
              height: 40,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ShowNotes(),
                  ),
                );
              },
              child: Text('go to show notes screen'),
            ),
          ],
        ),
      ),
    );
  }

  void _presentDataPicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 30)),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Provider.of<NoteProvider>(context, listen: false).close();
  }
}
