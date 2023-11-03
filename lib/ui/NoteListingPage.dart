import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_note/ui/TaskWidget.dart';

import '../blocs/notes_bloc/notes_bloc.dart';
import '../model/Note.dart';

class NoteListingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotesBloc(),
      child: Builder(builder: (context) {
        BlocProvider.of<NotesBloc>(context)
            .add(const LoadAllNoteEvent(noteList: []));
        return buildPage(context);
      }),
    );
  }

  Widget buildPage(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(automaticallyImplyLeading: false, title: const Text("Notes")),
      body: BlocBuilder<NotesBloc, NotesState>(
        builder: (context, state) {
          if (state is NotesInitialState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is NoteNoteFountState) {
            return Center(
                child: Text(state.message,
                    style: const TextStyle(fontSize: 20.0)));
          }
          if (state is NotesLoadedState) {
            return ListView.builder(
              itemCount: state.noteList.length,
              itemBuilder: (context, index) {
                Note _note = state.noteList[index];
                return TaskWidget(
                  note: _note,
                  onCheckEvent: (checkUncheck, note) {},
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
