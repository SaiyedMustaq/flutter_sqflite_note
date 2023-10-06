// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sqflite_note/database/DatabaseHelper.dart';

import '../model/Note.dart';
import 'AddUser.dart';

class OfflineUserList extends StatefulWidget {
  const OfflineUserList({super.key});

  @override
  State<OfflineUserList> createState() => _OfflineUserListState();
}

class _OfflineUserListState extends State<OfflineUserList> {
  List<Note> notes = [];
  bool isLoading = false;
  bool isAcceding = true;
  @override
  void initState() {
    getAllNots(isAcceding);
    super.initState();
  }

  Future getAllNots(bool value) async {
    setState(() => isLoading = true);
    notes = await DatabaseHelper.instance.readAllNotes(accedingByName: value);
    Future.delayed(const Duration(seconds: 2), () {
      isAcceding = true;
      setState(() => isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User List"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                setState(() => isLoading = true);
                Future.delayed(const Duration(seconds: 1), () {
                  isAcceding = !isAcceding;
                  notes.clear();
                  getAllNots(isAcceding);
                });
              },
              icon: const Icon(Icons.sort_by_alpha_sharp))
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notes.isEmpty
              ? const EmptyUserList()
              : UserList(
                  notes: notes,
                  onBackRefersh: () => getAllNots(isAcceding),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UserAdd(
                        noteObject: null,
                      ))).then((value) => getAllNots(isAcceding));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class EmptyUserList extends StatelessWidget {
  const EmptyUserList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("No user found"),
    );
  }
}

typedef OnBackRefersh = Function();

class UserList extends StatelessWidget {
  UserList({
    super.key,
    required this.notes,
    required this.onBackRefersh,
  });
  List<Note> notes;
  MenuItem? menuItem;
  OnBackRefersh onBackRefersh;

  @override
  Widget build(BuildContext context) {
    return StaggeredGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      children: notes
          .map(
            (e) => Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromRGBO(
                        int.parse(e.color.split(",")[0]),
                        int.parse(e.color.split(",")[1]),
                        int.parse(e.color.split(",")[2]),
                        1),
                    borderRadius:
                        const BorderRadius.all(Radius.circular(10.0))),
                child: ListTile(
                  contentPadding: const EdgeInsets.only(left: 8, right: 0),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              e.title,
                              style: const TextStyle(
                                  fontSize: 22.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                          PopupMenuButton<MenuItem>(
                            color: Colors.black,
                            initialValue: menuItem,
                            onSelected: (MenuItem item) {},
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<MenuItem>>[
                              PopupMenuItem<MenuItem>(
                                value: MenuItem.edit,
                                child: TextButton(
                                    child: const Text('Edit',
                                        style: TextStyle(color: Colors.white)),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UserAdd(noteObject: e)))
                                          .then((value) {
                                        onBackRefersh();
                                      });
                                    }),
                              ),
                              PopupMenuItem<MenuItem>(
                                value: MenuItem.delete,
                                child: TextButton(
                                    child: const Text('Delete',
                                        style: TextStyle(color: Colors.white)),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      _showMyDialog(context, e.id!);
                                    }),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(e.description,
                          style: const TextStyle(
                              fontSize: 15.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w400)),
                    ],
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Future<void> _showMyDialog(BuildContext context, int id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Alert"),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Are you won't to sure remove ?"),
                Text("Remove data from table"),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: const Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Yes'),
                  onPressed: () {
                    DatabaseHelper.instance.delete(id);
                    Navigator.of(context).pop();
                    onBackRefersh();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

enum MenuItem { edit, delete }
