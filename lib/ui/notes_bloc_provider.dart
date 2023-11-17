import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_note/ui/notesk_widget.dart';
import 'package:sqflite_note/ui/note_listing.dart';

import '../blocs/notes_bloc/notes_bloc.dart';
import '../model/Note.dart';
import 'AddUser.dart';

class NotesBlocProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotesBloc(),
      child: Builder(builder: (context) {
        BlocProvider.of<NotesBloc>(context)
            .add(const LoadAllNoteEvent(noteList: []));
        return const NoteListPage();
      }),
    );
  }
}
