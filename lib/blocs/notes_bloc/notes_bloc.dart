import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sqflite_note/repository/NoteRepository.dart';
import '../../model/Note.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  bool ascending = true;
  List<Note> noteList = [];
  List<Note> noteCompleteList = [];
  NotesBloc() : super(const NotesLoadedState()) {
    on<LoadAllNoteEvent>(_getAllNotes);
    on<AddNoteEvent>(_addNewNote);
    on<UpdateNoteEvent>(_updateNote);
    on<IsCompleteEvent>(_isCompleteNote);
    on<DeleteNoteEvent>(_deleteNote);
    on<NoteLoadEvent>(_noteLoad);
    on<NoteSearchEvents>(_searchNote);
  }

  void _searchNote(NoteSearchEvents event, Emitter<NotesState> emit) {
    List<Note> searchList = noteList
        .where((element) =>
            element.title.toLowerCase().toString() ==
            event.queary.toString().toLowerCase())
        .toList();
    print("SEARCH LIST==>${searchList}");
    emit(NotesLoadedState(noteList: searchList));
  }

  void _getAllNotes(LoadAllNoteEvent event, Emitter<NotesState> emit) async {
    emit(NotesInitialState());
    noteList = await NoteRepository.noteRepository.getAllNotes();
    if (noteList.isEmpty) {
      emit(const NoteNoteFountState(message: "Notes note added yer"));
    } else {
      emit(NotesLoadedState(
          noteList: noteList, noteCompletedList: noteCompleteList));
    }
  }

  void _addNewNote(AddNoteEvent event, Emitter<NotesState> emit) {
    NoteRepository.noteRepository.addNewNote(event.note);
  }

  void _noteLoad(NoteLoadEvent event, Emitter<NotesState> emit) async {
    emit(NoteLoadingState());
    await Future.delayed(const Duration(seconds: 2));
    emit(NoteLoadState(note: event.note));
  }

  void _updateNote(UpdateNoteEvent event, Emitter<NotesState> emit) {
    final state = this.state;
    if (state is NotesLoadedState) {
      noteList = (state.noteList.map((task) {
        return task.id == event.note.id ? event.note : task;
      })).toList();
      NoteRepository.noteRepository.updateNote(event.note);
      emit(NotesLoadedState(noteList: noteList));
    }
  }

  void _isCompleteNote(IsCompleteEvent event, Emitter<NotesState> emit) {
    final state = this.state;
    if (state is NotesLoadedState) {
      state.noteList.removeWhere((element) => element.id == event.note.id);
      NoteRepository.noteRepository.updateNote(event.note);
      emit(NotesLoadedState(
          noteList: state.noteList, noteCompletedList: noteCompleteList));
    }
  }

  void _deleteNote(DeleteNoteEvent event, Emitter<NotesState> emit) {
    NoteRepository.noteRepository.deleteNote(event.note.id!);
    noteList.remove(event.note);
    emit(NotesLoadedState(
        noteList: noteList, noteCompletedList: noteCompleteList));
  }
}
