// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_note/blocs/notes_bloc/notes_bloc.dart';
import '../model/Note.dart';

class TaskWidget extends StatelessWidget {
  final Note note;
  Function(String value, Note id) onCheckEvent;
  TaskWidget({super.key, required this.note, required this.onCheckEvent});

  @override
  Widget build(BuildContext context) {
    bool _status = note.isComplete.contains("false") ? false : true;
    print("object=>$_status");
    return BlocListener<NotesBloc, NotesState>(
      listener: (context, state) {},
      child: ListTile(
        leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.star, color: Colors.amber)),
        title: Text(
          note.title,
          style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
              decoration: note.isComplete == "1"
                  ? TextDecoration.lineThrough
                  : TextDecoration.none),
        ),
        subtitle: Text("${note.time} / ${note.date}"),
        trailing: Checkbox(
          value: note.isComplete.contains("false") ? false : true,
          onChanged: (value) {
            onCheckEvent(value! ? "true" : "false", note);
          },
        ),
      ),
    );
  }
}

class IsComplete extends StatelessWidget {
  IsComplete({super.key, required this.onTap, required this.status});
  Function(String value) onTap;
  String status;

  @override
  Widget build(BuildContext context) {
    bool _status = status.contains("false") ? false : true;
    print("object=>$status");
    return Checkbox(
      value: _status,
      onChanged: (value) {
        onTap(value! ? "1" : "0");
      },
    );
  }
}
