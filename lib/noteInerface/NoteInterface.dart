import '../model/Note.dart';

abstract class NoteApi {
  Future<List<Note>> getAllNotes();
  Future<int> getRowCount();
  Future updateNote(int id);
  Future deleteNote(int id);
  Future<List<Note>> alphabaticOrder();
  Future<void> close();
}
