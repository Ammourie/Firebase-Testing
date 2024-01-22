import 'package:fb_testing/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;
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

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kToolbarHeight + 50,
        shadowColor: Colors.black,
        elevation: 10,
        surfaceTintColor: Colors.transparent,
        title: searchTextField(),

        // title: Text(
        //   user.name != null ? "Hello ${user.name}" : "Home Screen",
        //   style: Theme.of(context).textTheme.titleLarge,
        // ),
        // actions: [
        //   TextButton(
        //       onPressed: () async {
        //         await _authService.logout();
        //       },
        //       child: const Text("logout"))
        // ],
      ),
      body: StreamProvider<List<NoteModel>>.value(
          value: DatabaseService(id: user.id).notes,
          initialData: [NoteModel(id: "-1")],
          child: const NotesListWidget()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          docModalShow(context, user.id!);
        },
        child: const Icon(
          Icons.add_outlined,
          size: 35,
        ),
      ),
    );
  }
}

class searchTextField extends StatefulWidget {
  searchTextField({
    super.key,
  });

  @override
  State<searchTextField> createState() => _searchTextFieldState();
}

class _searchTextFieldState extends State<searchTextField> {
  bool isRTL(String text) {
    return intl.Bidi.detectRtlDirectionality(text);
  }

  TextEditingController _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (value) {
        setState(() {
          _textController.text = value;
        });
      },
      textDirection:
          isRTL(_textController.text) ? TextDirection.rtl : TextDirection.ltr,
      decoration: InputDecoration(
        hintText: "search ...",
        hintStyle: Theme.of(context).textTheme.bodyLarge!,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _textController.text = "";
            });
          },
          child: const Icon(Icons.clear),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide.none,
        ),
        fillColor: Theme.of(context).colorScheme.primaryContainer,
      ),
    );
  }
}

void docModalShow(
  BuildContext context,
  String id, {
  String? docId,
  String initNote = "",
}) {
  bool adding = false;
  String note = initNote;
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
        child: StatefulBuilder(builder: (context, state) {
          return Form(
            key: key,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextFormField(
                  onChanged: (s) => note = s,
                  initialValue: note,
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
                adding
                    ? const LoadingWidget()
                    : ElevatedButton(
                        onPressed: () async {
                          if (key.currentState!.validate()) {
                            state(() => adding = true);
                            await DatabaseService(id: id).updateUserData(
                              note: note,
                              date: DateTime.now().toString(),
                              id: docId,
                            );
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor:
                              Colors.white, //change background color of button
                          backgroundColor:
                              Colors.black, //change text color of button
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: Size(180, 50), //////// HERE

                          elevation: 15.0,
                        ),
                        child: Text(
                          docId != null ? "Update" : "Add",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.white, fontSize: 20),
                        ),
                      ),
                const SizedBox(height: 20),
                // SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
              ],
            ),
          );
        }),
      );
    },
  );
}
