import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_note/model/Note.dart';
import 'package:sqflite_note/ui/AddUser.dart';
import 'package:sqflite_note/ui/notesk_widget.dart';

import '../blocs/notes_bloc/notes_bloc.dart';

class NoteListPage extends StatefulWidget {
  const NoteListPage({super.key});

  @override
  State<NoteListPage> createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  TextEditingController searchController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
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
          print("build call-->$state");

          if (state is NotesLoadedState) {
            return Column(children: [
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
                      bloc.add(NoteSearchEvents(queary: value));
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      ...state.noteList.map(
                        (note) => InkWell(
                          onTap: (() {
                            bloc.add(UpdateNoteEvent(
                                note: note.copywith(
                                    isComplete:
                                        note.isComplete.contains("false")
                                            ? "true"
                                            : "false")));
                          }),
                          child: TaskWidget(
                            note: note,
                            onCheckEvent: (String value, Note note) {
                              context.read<NotesBloc>().add(UpdateNoteEvent(
                                  note: note.copywith(
                                      isComplete:
                                          note.isComplete.contains("false")
                                              ? "true"
                                              : "false")));
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 80,
                      )
                    ],
                  ),
                ),
              )
            ]);
          }
          if (state is NotesInitialState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is NoteNoteFountState) {
            return Center(
                child: Text(state.message,
                    style: const TextStyle(fontSize: 20.0)));
          }
          return Container();
        },
      ),
    );
  }
}
