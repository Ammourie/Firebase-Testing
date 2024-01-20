import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/note.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
import '../../widgets/notes_widget.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserModel>(context);

    return StreamProvider<List<NoteModel>>.value(
      value: DatabaseService(id: user.id).notes,
      initialData: const [],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            user.name != null ? "Hello ${user.name}" : "Home Screen",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          actions: [
            TextButton(
                onPressed: () async {
                  await _authService.logout();
                },
                child: const Text("logout"))
          ],
        ),
        body: const NotesListWidget(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            modalShow(context, user.id!);
          },
          child: const Icon(
            Icons.add_outlined,
            size: 35,
          ),
        ),
      ),
    );
  }
}

void modalShow(BuildContext context, String id) {
  String note = "";
  GlobalKey<FormState> key = GlobalKey();
  showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.white,
    context: context,
    builder: (c) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          top: 20,
          right: 20,
        ),
        child: Form(
          key: key,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextFormField(
                onChanged: (s) => note = s,
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return "enter something bro";
                  }
                  return null;
                },
                maxLines: 7,
                decoration: const InputDecoration(
                  hintText: "Enter Your note here",
                ),
                maxLength: 300,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.black),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (key.currentState!.validate()) {
                    await DatabaseService(id: id).updateUserData(
                        note: note, date: DateTime.now().toString());
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor:
                      Colors.white, //change background color of button
                  backgroundColor: Colors.black, //change text color of button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: Size(180, 50), //////// HERE

                  elevation: 15.0,
                ),
                child: Text(
                  "Add",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.white, fontSize: 20),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    },
  );
}
