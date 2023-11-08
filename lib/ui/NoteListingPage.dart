import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_note/ui/TaskWidget.dart';

import '../blocs/notes_bloc/notes_bloc.dart';
import '../model/Note.dart';
import 'AddUser.dart';

class NoteListingPage extends StatelessWidget {
  TextEditingController searchController = TextEditingController(text: "");
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
    final bloc = BlocProvider.of<NotesBloc>(context);
    return Scaffold(
      appBar:
          AppBar(automaticallyImplyLeading: false, title: const Text("Notes")),
      floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NoteAddEditPage(
                            note: null,
                          ))).then((value) {
                bloc.add(const LoadAllNoteEvent(noteList: []));
              }),
          child: const Icon(Icons.add)),
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
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(color: Colors.black),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextFormField(
                    controller: searchController,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        context
                            .read<NotesBloc>()
                            .add(NoteSearchEvents(queary: value));
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: "Search",
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                  itemCount: state.noteList.length,
                  itemBuilder: (context, index) {
                    Note noteModel = state.noteList[index];
                    return TaskWidget(
                      note: noteModel,
                      onCheckEvent: (checkUncheck, note) {
                        context.read<NotesBloc>().add(IsCompleteEvent(
                            note: note.copywith(
                                isComplete: checkUncheck, id: note.id)));
                      },
                    );
                  },
                ))
              ],
            );
          }
          return Container();
        },
      ),
    );
  }

  Future gotoAddEditPage(BuildContext context, Note? note) async {}
}
