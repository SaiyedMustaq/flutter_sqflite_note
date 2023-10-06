// ignore_for_file: must_be_immutable, no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../database/DatabaseHelper.dart';
import '../model/Note.dart';

class UserAdd extends StatefulWidget {
  UserAdd({super.key, required this.noteObject});
  Note? noteObject;

  @override
  State<UserAdd> createState() => _UserAddState(note: noteObject);
}

class _UserAddState extends State<UserAdd> {
  TextEditingController titleController = TextEditingController(text: "");
  TextEditingController descController = TextEditingController(text: "");
  // create some values
  Color pickerColor = const Color(0xff000000);
  Color currentColor = const Color(0xff000000);

// ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
    Navigator.pop(context);
  }

  _UserAddState({required this.note});
  Note? note;
  bool isEdit = false;

  @override
  void initState() {
    if (note != null) {
      titleController.text = note!.title;
      descController.text = note!.description;
      isEdit = true;
      setState(() {});
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                print("PICKER COLOR==>$colorInRGB");
                if (isEdit) {
                  _note = Note(
                    id: note!.id,
                    title: titleController.text,
                    description: descController.text,
                    color: colorInRGB,
                  );
                  DatabaseHelper.instance.update(_note);
                } else {
                  _note = Note(
                    title: titleController.text,
                    description: descController.text,
                    color: colorInRGB,
                  );
                  DatabaseHelper.instance.create(_note);
                }
                titleController.clear();
                descController.clear();
                Navigator.pop(context, true);
              },
              icon: const Icon(Icons.save))
        ],
      ),
      body: Padding(
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => viewBottomSheet(context),
        child: const Icon(Icons.color_lens),
      ),
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
