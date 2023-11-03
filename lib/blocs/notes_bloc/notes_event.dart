part of 'notes_bloc.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();
  @override
  List<Object> get props => [];
}

class LoadAllNoteEvent extends NotesEvent {
  final List<Note> noteList;
  const LoadAllNoteEvent({required this.noteList});
  List<Object> get pros => [noteList];
}

class AddNoteEvent extends NotesEvent {
  final Note note;
  const AddNoteEvent({required this.note});
  List<Object> get pros => [note];
}

class UpdateNoteEvent extends NotesEvent {
  final Note note;
  const UpdateNoteEvent({required this.note});
  List<Object> get pros => [note];
}

class DeleteNoteEvent extends NotesEvent {
  final Note note;
  const DeleteNoteEvent({required this.note});
  List<Object> get pros => [note];
}

class IsCompleteEvent extends NotesEvent {
  final Note note;
  const IsCompleteEvent({required this.note});
  List<Object> get pros => [note];
}
