import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sqflite_note/repository/NoteRepository.dart';

import '../../database/DatabaseHelper.dart';
import '../../model/Note.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  bool ascending = true;
  List<Note> noteList = [];
  NotesBloc() : super(const NotesLoadedState()) {
    // on<NotesEvent>((event, emit) {
    //   if (event is LoadAllNoteEvent) {
    //     _getAllNotes(event, emit);
    //   }
    //   if (event is AddNoteEvent) {
    //     _addNewNote(event, emit);
    //   }
    //   if (event is UpdateNoteEvent) {
    //     _updateNote(event, emit);
    //   }
    //   if (event is DeleteNoteEvent) {
    //     _deleteNote(event, emit);
    //   }
    //   if (event is UpdateNoteEvent) {
    //     _updateNewNote(event, emit);
    //   }
    //   if (event is IsCompleteEvent) {
    //     _isCompleteNote(event, emit);
    //   }
    // });
    on<LoadAllNoteEvent>(_getAllNotes);
    on<AddNoteEvent>(_addNewNote);
    on<UpdateNoteEvent>(_updateNewNote);
    on<IsCompleteEvent>(_isCompleteNote);
    on<DeleteNoteEvent>(_deleteNote);
  }

  void _getAllNotes(
    LoadAllNoteEvent event,
    Emitter<NotesState> emit,
  ) async {
    emit(NotesInitialState());
    //noteList = await DatabaseHelper.instance.readAllNotes(accedingByName: true);
    noteList = await NoteRepository.noteRepository.getAllNotes();
    if (noteList.isEmpty) {
      emit(const NoteNoteFountState(message: "Note note added yer"));
    } else {
      emit(NotesLoadedState(noteList: noteList));
    }
  }

  void _addNewNote(
    AddNoteEvent event,
    Emitter<NotesState> emit,
  ) {}

  void _updateNote(
    UpdateNoteEvent event,
    Emitter<NotesState> emit,
  ) {}

  void _updateNewNote(
    UpdateNoteEvent event,
    Emitter<NotesState> emit,
  ) {}

  void _isCompleteNote(
    IsCompleteEvent event,
    Emitter<NotesState> emit,
  ) {}

  void _deleteNote(
    DeleteNoteEvent event,
    Emitter<NotesState> emit,
  ) {}
}
