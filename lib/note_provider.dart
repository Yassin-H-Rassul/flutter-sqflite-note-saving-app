import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sql_proj/note_model.dart';

class NoteProvider extends ChangeNotifier {
  final String tableNote = 'note';
  final String columnId = 'id';
  final String columnNoteContent = 'noteContent';
  final String columnSelectedDate = 'selectedDate';
  Database? db;

  Future open(String path) async {
    print('//////////////////////////inside open method');
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $tableNote ( 
  $columnId integer primary key autoincrement, 
  $columnNoteContent text not null,
  $columnSelectedDate text not null)
''');

      print('>>>>>>>>>>>>>>>>>>>>> table created.');
    });
  }

  Future<Note> insert(Note note) async {
    note.id = await db!.insert(tableNote, note.toMap());
    return note;
  }

  Future<Note?> getNote(int id) async {
    List<Map> maps = await db!.query(tableNote,
        columns: [columnId, columnNoteContent, columnSelectedDate],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Note.fromMap(maps.first as Map<String, dynamic>);
    }
    return null;
  }

  Future<List<Note>> fetchNotes() async {
    List<Note> list = [];
    List<Map<String, dynamic>> docs = await db!.rawQuery('SELECT * FROM note');
    docs.forEach((element) {
      final Note note = Note.fromMap(element);
      list.add(note);
    });
    return list;
  }

  Future<int> delete(int id) async {
    return await db!.delete(tableNote, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(Note Note) async {
    return await db!.update(tableNote, Note.toMap(),
        where: '$columnId = ?', whereArgs: [Note.id]);
  }

  Future close() async => db!.close();
}
