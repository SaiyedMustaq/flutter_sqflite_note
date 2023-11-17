import '../model/Note.dart';

abstract class NoteApi {
  Future<List<Note>> getAllNotes();
  Future addNewNote(Note note);
  Future<int> getRowCount();
  Future updateNote(Note id);
  Future deleteNote(int id);
  Future<List<Note>> alphabaticOrder();
  Future<void> close();
  Future<int> clearCompleted();
  Future<int> completeAll({required bool isCompleted});
}
