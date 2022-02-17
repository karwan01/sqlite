import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sql_project/src/models/note_model.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstrcutor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstrcutor();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'notes.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''

      CREATE TABLE notes(
        id INTEGER PRIMARY KEY,
        note TEXT,
        date TEXT
      )
    
    ''');
  }

  Future<List<NoteModel>> getNotes() async {
    Database db = await instance.database;

    var notes = await db.rawQuery('SELECT * FROM notes');
    List<NoteModel> noteList =
        notes.isNotEmpty ? notes.map((e) => NoteModel.fromMap(e)).toList() : [];

    return noteList;
  }

  Future<int> add(NoteModel note) async {
    Database db = await instance.database;
    return await db.insert('notes', note.toMap());
  }

  Future<int> remove(int id) async {
    Database db = await instance.database;
    return await db.delete('notes', where: 'id= ?', whereArgs: [id]);
  }

  Future<int> update(NoteModel note) async {
    Database db = await instance.database;
    return await db
        .update('notes', note.toMap(), where: 'id= ?', whereArgs: [note.id]);
  }
}
