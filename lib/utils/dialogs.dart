import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/note.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';

class MyDialogs {
  static void showcupertinoAlertDialog(
      {String? title,
      String? content,
      required BuildContext context,
      void Function()? onYes,
      void Function()? onNo}) {
    showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: title == null ? null : Text(title),
              content: content == null ? null : Text(content),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: onYes ?? () => Navigator.pop(context),
                  child: const Text("Yes"),
                ),
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  onPressed: onNo ?? () => Navigator.pop(context),
                  child: const Text("No"),
                )
              ],
            ));
  }

  // static void showCategoryAddDialog(
  //     {CategoryModel? categoryModel,
  //     required BuildContext context,
  //     void Function()? onYes,
  //     void Function()? onNo}) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) => AlertDialog(
  //       title: Text(
  //         (categoryModel == null) ? "Create a new Category" : "Edit Category",
  //         style: Theme.of(context)
  //             .textTheme
  //             .titleMedium!
  //             .copyWith(color: Colors.black),
  //       ),
  //       content: Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               TextFormField(
  //                 decoration: const InputDecoration(
  //                     contentPadding: EdgeInsets.symmetric(
  //                       vertical: 2,
  //                       horizontal: 10,
  //                     ),
  //                     label: Text("Name")),
  //               ),
  //               const SizedBox(height: 10),
  //                // ColorIndicator(
  //           //   width: 44,
  //           //   height: 44,
  //           //   borderRadius: 4,
  //           //   color: dialogPickerColor,
  //           //   onSelectFocus: false,
  //           //   onSelect: () async {
  //           //     // Store current color before we open the dialog.
  //           //     final Color colorBeforeDialog = dialogPickerColor;
  //           //     // Wait for the picker to close, if dialog was dismissed,
  //           //     // then restore the color we had before it was opened.
  //           //     if (!(await colorPickerDialog())) {
  //           //       setState(() {
  //           //         dialogPickerColor = colorBeforeDialog;
  //           //       });
  //           //     }
  //           //   },
  //           // ),
  //             ],
  //           )),
  //       actions: [
  //         CupertinoDialogAction(
  //           textStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
  //                 fontSize: 20,
  //               ),
  //           isDefaultAction: true,
  //           onPressed: onYes ?? () => Navigator.pop(context),
  //           child: const Text("Create"),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  static showNoteDialog(
      {NoteModel? noteModel,
      required BuildContext context,
      required String userid,
      void Function()? then}) async {
    TextEditingController title = TextEditingController();
    TextEditingController note = TextEditingController();
    if (noteModel != null) note.text = noteModel.note!;
    if (noteModel != null) title.text = noteModel.title!;
    await showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(
          (noteModel == null) ? "Create a new Note" : "Edit Note",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.black),
        ),
        content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Title",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: Colors.black),
                ),
                CupertinoTextField(
                  controller: title,
                  maxLength: 30,
                ),
                const SizedBox(height: 20),
                Text(
                  "Note",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: Colors.black),
                ),
                CupertinoTextField(
                  controller: note,
                  maxLines: 3,
                ),
              ],
            )),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () async {
              log(title.text);
              log(note.text);
              if (note.text != "") {
                Navigator.pop(context);
                if (title.text == "") {
                  title.text = "No Title";
                }
                NoteModel m = NoteModel(
                    title: title.text,
                    note: note.text,
                    id: noteModel?.id,
                    date: DateTime.now().toString(),
                    color: AuthService.noteColors[
                        math.Random().nextInt(AuthService.noteColors.length)]);
                await DatabaseService(id: userid).updateUserNote(note: m);
              }
            },
            child: Text((noteModel == null) ? "Create" : "Edit"),
          ),
          CupertinoDialogAction(
            isDefaultAction: false,
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }
}
