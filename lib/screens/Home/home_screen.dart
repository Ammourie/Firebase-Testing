import 'package:fb_testing/utils/dialogs.dart';
import 'package:fb_testing/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/drawer/gf_drawer.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

import '../../models/note.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
import '../../widgets/notes_widget.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserModel>(context);

    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        toolbarHeight: kToolbarHeight + 50,
        shadowColor: Colors.black,
        elevation: 10,
        surfaceTintColor: Colors.transparent, centerTitle: false,
        title: const SearchTextField(),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.all(10.0),
        //     child: GestureDetector(
        //       child: Icon(
        //         Icons.menu,
        //         color: Theme.of(context).buttonTheme.colorScheme!.primary,
        //         size: 35,
        //       ),
        //     ),
        //   ),
        // ],
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
          initialData: [],
          child: const NotesListWidget()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // docModalShow(context, user.id!);
          MyDialogs.showNoteDialog(context: context, userid: user.id!);
        },
        child: const Icon(
          Icons.add_outlined,
          size: 35,
        ),
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  MyDrawer({
    super.key,
  });
  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return GFDrawer(
      child: StreamBuilder<UserModel>(
        builder: (context, snapshot) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person_2_sharp,
                      color: Theme.of(context).primaryColor,
                      size: 150,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Text(
                      snapshot.hasData ? snapshot.data!.name ?? "" : "",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.normal,
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontSize: 27,
                          ),
                    ),
                  ),
                  Divider(
                    color: Theme.of(context).dividerColor,
                    thickness: 4,
                  ),
                  // const SizedBox(height: 10),
                  // Align(
                  //   alignment: AlignmentDirectional.centerStart,
                  //   child: Text(
                  //     "Categories",
                  //     style: Theme.of(context).textTheme.titleSmall,
                  //   ),
                  // ),
                  // const SizedBox(height: 10),
                  // StreamBuilder<List<CategoryModel>>(
                  //     stream: DatabaseService(id: user.id).categories,
                  //     builder: (context, snp) {
                  //       return !snp.hasData
                  //           ? Container()
                  //           : ListView.builder(
                  //               shrinkWrap: true,
                  //               physics: const NeverScrollableScrollPhysics(),
                  //               padding: EdgeInsets.zero,
                  //               itemCount: snp.data!.length,
                  //               itemBuilder: (context, index) {
                  //                 CategoryModel cat = snp.data![index];
                  //                 return ListTile(
                  //                   contentPadding: EdgeInsets.zero,
                  //                   title: Text(
                  //                     cat.name!,
                  //                     style: Theme.of(context)
                  //                         .textTheme
                  //                         .titleSmall!
                  //                         .copyWith(color: Color(cat.color!)),
                  //                   ),
                  //                   subtitle: Text(
                  //                     cat.count!.toString(),
                  //                     style: Theme.of(context)
                  //                         .textTheme
                  //                         .titleSmall!
                  //                         .copyWith(
                  //                             color: Color(cat.color!),
                  //                             fontSize: 15),
                  //                   ),
                  //                   trailing: Row(
                  //                     mainAxisSize: MainAxisSize.min,
                  //                     children: [
                  //                       GestureDetector(
                  //                         onTap: () {},
                  //                         child: const Icon(
                  //                           Icons.edit,
                  //                           color: Colors.green,
                  //                           size: 24,
                  //                         ),
                  //                       ),
                  //                       const SizedBox(width: 10),
                  //                       const Icon(
                  //                         Icons.delete,
                  //                         color: Colors.red,
                  //                         size: 24,
                  //                       ),
                  //                     ],
                  //                   ),
                  //                   leading: Icon(
                  //                     Icons.bookmark,
                  //                     color: Color(cat.color!),
                  //                     size: 24,
                  //                   ),
                  //                 );
                  //               },
                  //             );
                  //     }),
                  // Divider(color: Theme.of(context).dividerColor, thickness: 1),
                  // ListTile(
                  //   onTap: () {
                  //     // Navigator.push(
                  //     //     context,
                  //     //     MaterialPageRoute(
                  //     //         builder: (context) => const CategoryPage()));
                  //     // MyDialogs.showCategoryAddDialog(context: context);
                  //   },
                  //   contentPadding: EdgeInsets.zero,
                  //   title: Text(
                  //     "Add new category",
                  //     style: Theme.of(context)
                  //         .textTheme
                  //         .titleSmall!
                  //         .copyWith(color: Theme.of(context).primaryColor),
                  //   ),
                  //   leading: Icon(
                  //     Icons.bookmark_add,
                  //     color: Theme.of(context).primaryColor,
                  //     size: 24,
                  //   ),
                  // ),
                  // Divider(color: Theme.of(context).dividerColor, thickness: 4),
                  // ListTile(
                  //   contentPadding: EdgeInsets.zero,
                  //   title: Text(
                  //     "Settings",
                  //     style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  //           color: Colors.black,
                  //         ),
                  //   ),
                  //   leading: const Icon(
                  //     Icons.settings,
                  //     color: Colors.grey,
                  //     size: 24,
                  //   ),
                  // ),
                  const Spacer(),
                  ListTile(
                    onTap: () {
                      MyDialogs.showcupertinoAlertDialog(
                        context: context,
                        title: "Logout",
                        content: "Are you sure?",
                        onYes: () async {
                          Navigator.pop(context);
                          await _authService.logout();
                        },
                      );
                    },
                    tileColor: Colors.red.shade100,
                    leading: const Icon(
                      Icons.logout_outlined,
                      color: Colors.red,
                    ),
                    title: Text(
                      "Logout",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Colors.red,
                          fontWeight: FontWeight.normal,
                          fontSize: 22),
                    ),
                  )
                ],
              ),
            ),
          );
        },
        stream: AuthService().authStateChangeStream,
      ),
    );
  }
}

class SearchTextField extends StatefulWidget {
  const SearchTextField({
    super.key,
  });

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  bool isRTL(String text) {
    return intl.Bidi.detectRtlDirectionality(text);
  }

  final TextEditingController _textController = TextEditingController();
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
                            NoteModel noteModel = NoteModel(
                                note: note,
                                date: DateTime.now().toString(),
                                id: docId);
                            await DatabaseService(id: id)
                                .updateUserNote(note: noteModel);
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
                          minimumSize: const Size(180, 50), //////// HERE

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
