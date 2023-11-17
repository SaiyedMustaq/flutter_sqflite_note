part of 'notes_bloc.dart';

abstract class NotesState extends Equatable {
  const NotesState();

  @override
  List<Object> get props => [];
}

class NotesInitialState extends NotesState {}

class NotesLoadedState extends NotesState {
  final List<Note> noteList;

  const NotesLoadedState({
    this.noteList = const <Note>[],
  });
  List<Object> get pros => [noteList];
}

class CompleteNotesLoadedState extends NotesState {
  final List<Note> noteList;
  const CompleteNotesLoadedState({this.noteList = const <Note>[]});
  List<Object> get pros => [noteList];
}

class NoteNoteFountState extends NotesState {
  final String message;
  const NoteNoteFountState({required this.message});
}

class NoteSearchState extends NotesState {
  final List<Note> noteList;
  const NoteSearchState({this.noteList = const <Note>[]});
  List<Object> get pros => [noteList];
}

class NoteCompleteState extends NotesState {
  final bool done;
  const NoteCompleteState({required this.done});
  List<Object> get pros => [done];
}

class NoteDeleteState extends NotesState {
  final Note notes;
  const NoteDeleteState({required this.notes});
  List<Object> get pros => [notes];
}

class NoteLoadingState extends NotesState {}

class NoteLoadState extends NotesState {
  final Note note;
  const NoteLoadState({required this.note});
}
