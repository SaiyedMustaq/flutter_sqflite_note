// ignore_for_file: recursive_getters

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/Note.dart';

class DatabaseHelper {
  static const databaseName = "offlineStore";
  static const databaseVersion = 1;
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tableNotes (
            ${NoteFields.id} INTEGER PRIMARY KEY,
            ${NoteFields.title} TEXT NOT NULL,
            ${NoteFields.description} TEXT NOT NULL,
            ${NoteFields.color} TEXT NOT NULL
          )
          ''');
  }

  Future<Note> create(Note note) async {
    final db = await instance.database;
    final id = await db.insert(tableNotes, note.toJson());
    return note.copywith(id: id);
  }

  Future<List<Note>> readAllNotes({bool accedingByName = true}) async {
    final db = await instance.database;
    var orderBy = "${NoteFields.title} ${accedingByName ? "ASC" : "DESC"}";
    final result = await db.query(tableNotes, orderBy: orderBy);
    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future<int> queryRowCount() async {
    final results =
        await _database!.rawQuery('SELECT COUNT(*) FROM $tableNotes');
    return Sqflite.firstIntValue(results) ?? 0;
  }

  Future<int> update(Note note) async {
    final db = await instance.database;
    return db.update(
      tableNotes,
      note.toJson(),
      where: '${NoteFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableNotes,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<Note> readNote(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableNotes,
      columns: NoteFields.values,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Note>> accendingOrder() async {
    final db = await instance.database;
    const orderBy = "${NoteFields.title} ASC";
    final result = await db.query(tableNotes, orderBy: orderBy);
    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
