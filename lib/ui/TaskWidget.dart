import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/notes_bloc/notes_bloc.dart';
import '../model/Note.dart';

class TaskWidget extends StatelessWidget {
  final Note note;
  Function(String value, Note id) onCheckEvent;
  TaskWidget({super.key, required this.note, required this.onCheckEvent});

  @override
  Widget build(BuildContext context) {
    //print("NOTE ==>${note.toJson()}");
    return ListTile(
      leading: IconButton(
          onPressed: () {}, icon: const Icon(Icons.star, color: Colors.amber)),
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
      trailing: IsComplete(
        onTap: (String value) => onCheckEvent(value, note),
        status: false,
      ),
    );
  }
}

class IsComplete extends StatelessWidget {
  IsComplete({super.key, required this.onTap, required this.status});
  Function(String value) onTap;
  bool status;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: status,
      onChanged: (value) {
        onTap(value! ? "1" : "0");
      },
    );
  }
}
