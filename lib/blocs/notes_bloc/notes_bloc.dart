import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sqflite_note/repository/NoteRepository.dart';
import '../../model/Note.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  bool ascending = true;
  NotesBloc() : super(const NotesLoadedState()) {
    on<LoadAllNoteEvent>(_onLoadTask);
    on<AddNoteEvent>(_onAddTask);
    on<UpdateNoteEvent>(_onUpdateTask);
    //on<IsCompleteEvent>(_isCompleteNote);
    on<DeleteNoteEvent>(_onDeleteTask);
    //on<NoteLoadEvent>(_noteLoad);
    //on<NoteSearchEvents>(_searchNote);
  }

  Future<void> _onLoadTask(NotesEvent event, Emitter<NotesState> emit) async {
    emit(NotesInitialState());
    try {
      final tasks = await NoteRepository.noteRepository.getAllNotes();
      emit(NotesLoadedState(noteList: tasks));
    } catch (e) {
      emit(NoteNoteFountState(message: e.toString()));
    }
  }

  void _onAddTask(AddNoteEvent event, Emitter<NotesState> emit) {
    final state = this.state;
    if (state is NotesLoadedState) {
      emit(NotesLoadedState(
          noteList: List.from(state.noteList)..add(event.note)));
    }
  }

  void _onDeleteTask(DeleteNoteEvent event, Emitter<NotesState> emit) {
    final state = this.state;
    if (state is NotesLoadedState) {
      List<Note> tasks = state.noteList.where((task) {
        return task.id != event.note.id;
      }).toList();
      emit(NotesLoadedState(noteList: tasks));
    }
  }

  void _onUpdateTask(UpdateNoteEvent event, Emitter<NotesState> emit) async {
    final state = this.state;
    List<Note> tasks = [];
    if (state is NotesLoadedState) {
      tasks = (state.noteList.map((task) {
        return task.id == event.note.id ? event.note : task;
      })).toList();
      await NoteRepository.noteRepository.updateNote(event.note);
    }
    emit(NotesLoadedState(noteList: tasks));
  }

  // void _searchNote(NoteSearchEvents event, Emitter<NotesState> emit) async {
  //   List<Note> searchList = noteList
  //       .where((element) => element.title
  //           .toLowerCase()
  //           .toString()
  //           .contains(event.queary.toString().toLowerCase()))
  //       .toList();

  //   emit(NotesLoadedState(noteList: searchList));
  // }

  // void _getAllNotes(LoadAllNoteEvent event, Emitter<NotesState> emit) async {
  //   emit(NotesInitialState());
  //   noteList = await NoteRepository.noteRepository.getAllNotes();
  //   if (noteList.isEmpty) {
  //     emit(const NoteNoteFountState(message: "Notes note added yer"));
  //   } else {
  //     emit(NotesLoadedState(noteList: noteList));
  //   }
  // }

  // void _addNewNote(AddNoteEvent event, Emitter<NotesState> emit) {
  //   NoteRepository.noteRepository.addNewNote(event.note);
  // }

  // void _noteLoad(NoteLoadEvent event, Emitter<NotesState> emit) async {
  //   emit(NoteLoadingState());
  //   await Future.delayed(const Duration(seconds: 2));
  //   emit(NoteLoadState(note: event.note));
  // }

  // void _updateNote(UpdateNoteEvent event, Emitter<NotesState> emit) {
  //   final state = this.state;
  //   if (state is NotesLoadedState) {
  //     noteList = (state.noteList.map((task) {
  //       return task.id == event.note.id ? event.note : task;
  //     })).toList();
  //     NoteRepository.noteRepository.updateNote(event.note);
  //     emit(NotesLoadedState(noteList: noteList));
  //   }
  // }

  // void _isCompleteNote(IsCompleteEvent event, Emitter<NotesState> emit) {
  //   final state = this.state;
  //   if (state is NotesLoadedState) {
  //     List<Note> tasks = (state.noteList.map((task) {
  //       return task.id == event.note.id ? event.note : task;
  //     })).toList();
  //     emit(NotesLoadedState(noteList: tasks));
  //   }
  // }

  // void _deleteNote(DeleteNoteEvent event, Emitter<NotesState> emit) {
  //   NoteRepository.noteRepository.deleteNote(event.note.id!);
  //   noteList.remove(event.note);
  //   emit(NotesLoadedState(noteList: noteList));
  // }
}
