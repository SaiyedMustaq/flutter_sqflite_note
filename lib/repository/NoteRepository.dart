import 'package:sqflite_note/database/DatabaseHelper.dart';
import 'package:sqflite_note/model/Note.dart';
import 'package:sqflite_note/noteInerface/NoteInterface.dart';

class NoteRepository extends NoteApi {
  NoteRepository._();
  static NoteRepository noteRepository = NoteRepository._();
  @override
  Future<List<Note>> alphabaticOrder() async =>
      await DatabaseHelper.instance.readAllNotes();

  @override
  Future<void> close() async => await DatabaseHelper.instance.close();

  @override
  Future<List<Note>> getAllNotes() async =>
      await DatabaseHelper.instance.readAllNotes();

  @override
  Future<int> getRowCount() async =>
      await DatabaseHelper.instance.queryRowCount();

  @override
  Future<int> deleteNote(int id) async =>
      await DatabaseHelper.instance.delete(id);

  @override
  Future updateNote(Note id) async => await DatabaseHelper.instance.update(id);

  @override
  Future addNewNote(Note note) async {
    await DatabaseHelper.instance.insertNewNote(note);
  }

  @override
  Future<int> clearCompleted() {
    throw UnimplementedError();
  }

  @override
  Future<int> completeAll({required bool isCompleted}) {
    throw UnimplementedError();
  }
}

class TodoNotFoundException implements Exception {}
