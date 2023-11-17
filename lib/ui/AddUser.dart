// ignore_for_file: must_be_immutable, no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';

import '../blocs/notes_bloc/notes_bloc.dart';
import '../model/Note.dart';

class NoteAddEditPage extends StatefulWidget {
  const NoteAddEditPage({super.key, required this.note});
  final Note? note;

  @override
  State<NoteAddEditPage> createState() => _NoteAddEditPageState();
}

class _NoteAddEditPageState extends State<NoteAddEditPage> {
  TextEditingController titleController = TextEditingController(text: "");
  TextEditingController descController = TextEditingController(text: "");
  Color pickerColor = const Color(0xff000000);
  Color currentColor = const Color(0xff000000);
  DateTime dateTimeNow = DateTime.now();
  @override
  void initState() {
    if (widget.note != null) {
      titleController.text = widget.note!.title;
      descController.text = widget.note!.description;
      setState(() {});
    }
    super.initState();
  }

  dateReturn(DateTime dateTime) {
    var formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(dateTime);
  }

  timeReturn(DateTime dateTime) {
    return DateFormat('kk:mm:a').format(dateTime);
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotesBloc(),
      child: Builder(builder: (context) {
        final bloc = BlocProvider.of<NotesBloc>(context);
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Nots"),
            actions: [
              IconButton(
                  onPressed: () {
                    late var _note;
                    String colorInRGB =
                        "${pickerColor.red},${pickerColor.green},${pickerColor.blue}";
                    if (titleController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Please Enter Title'),
                      ));
                      return;
                    }
                    if (descController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Please Enter Description'),
                      ));
                      return;
                    }
                    if (widget.note?.id != null) {
                      _note = Note(
                          id: widget.note!.id,
                          title: titleController.text,
                          description: descController.text,
                          color: colorInRGB,
                          isComplete: widget.note!.isComplete,
                          date: "${dateReturn(dateTimeNow)}",
                          time: "${timeReturn(dateTimeNow)}");
                      //DatabaseHelper.instance.update(_note);
                      bloc.add(UpdateNoteEvent(note: _note));
                    } else {
                      _note = Note(
                          title: titleController.text,
                          description: descController.text,
                          color: colorInRGB,
                          isComplete: 'false',
                          date: "${dateReturn(dateTimeNow)}",
                          time: "${timeReturn(dateTimeNow)}");
                      bloc.add(AddNoteEvent(note: _note));
                      //DatabaseHelper.instance.insertNewNote(_note);
                    }
                    titleController.clear();
                    descController.clear();
                    Navigator.pop(context, true);
                  },
                  icon: const Icon(Icons.save))
            ],
          ),
          body: BlocBuilder<NotesBloc, NotesState>(
            builder: (context, state) {
              if (state is NoteLoadingState) {
                return const Center(child: CircularProgressIndicator());
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: ListView(
                  children: [
                    TextFormField(
                      controller: titleController,
                      style: const TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter title",
                          hintStyle: TextStyle(
                              fontSize: 30.0,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey.shade800)),
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: descController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter description",
                          hintStyle: TextStyle(
                              fontSize: 20.0,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey.shade500)),
                    ),
                  ],
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
              onPressed: () => viewBottomSheet(context),
              child: const Icon(Icons.color_lens)),
        );
      }),
    );
  }

  void viewBottomSheet(BuildContext context) {
    showModalBottomSheet(
        useRootNavigator: true,
        elevation: 2.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        backgroundColor: Colors.white,
        useSafeArea: true,
        context: context,
        builder: (BuildContext bc) {
          return MaterialPicker(
            pickerColor: pickerColor,
            onColorChanged: changeColor,
          );
        });
  }
}
