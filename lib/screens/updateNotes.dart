import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:sql_proj/note_provider.dart';

import '../note_model.dart';

class updateNotes extends StatefulWidget {
  final Note note;
  final VoidCallback rebuildHandler;
  const updateNotes({
    Key? key,
    required this.note,
    required this.rebuildHandler,
  }) : super(key: key);

  @override
  _updateNotesState createState() => _updateNotesState();
}

class _updateNotesState extends State<updateNotes> {
  TextEditingController _noteController = TextEditingController();
  DateTime? _selectedDate;
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
          SizedBox(
            height: 50,
          ),
          ElevatedButton(
            onPressed: () {
              String previousNoteContent = widget.note.noteContent;
              Note newNote = Note(
                  id: widget.note.id,
                  noteContent: _noteController.text,
                  selectedDate: _selectedDate!.toIso8601String());
              Provider.of<NoteProvider>(context, listen: false).update(newNote);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('the note: ${previousNoteContent} updated'),
                ),
              );
              widget.rebuildHandler();
            },
            child: Text('update note'),
          ),
        ],
      )),
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
}
