import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';

import '../../models/note.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
import '../../utils/dialogs.dart';
import '../../widgets/notes_widget.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key, required this.noteModel});
  final NoteModel noteModel;

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lighten(Color(widget.noteModel.color!), .1),
      body: StreamBuilder(
          stream: AuthService().authStateChangeStream,
          builder: (context, snp) {
            return !snp.hasData
                ? Container()
                : SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Icon(
                                  Icons.arrow_back_rounded,
                                  color: Colors.black,
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      TextEditingController title =
                                          TextEditingController(
                                              text: widget.noteModel.title);
                                      TextEditingController note =
                                          TextEditingController(
                                              text: widget.noteModel.note);

                                      await showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            CupertinoAlertDialog(
                                          title: Text(
                                            "Edit Note",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(color: Colors.black),
                                          ),
                                          content: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    "Title",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall!
                                                        .copyWith(
                                                            color:
                                                                Colors.black),
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
                                                        .copyWith(
                                                            color:
                                                                Colors.black),
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
                                                if (note.text != "") {
                                                  Navigator.pop(context);
                                                  if (title.text == "") {
                                                    title.text = "No Title";
                                                  }

                                                  widget.noteModel.title =
                                                      title.text;
                                                  widget.noteModel.note =
                                                      note.text;
                                                  widget.noteModel.date =
                                                      DateTime.now().toString();

                                                  await DatabaseService(
                                                          id: snp.data!.id)
                                                      .updateUserNote(
                                                          note:
                                                              widget.noteModel);
                                                  setState(() {});
                                                }
                                              },
                                              child: Text("Edit"),
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
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          border: Border.all(
                                            color: GFColors.SUCCESS,
                                          )),
                                      child: const Icon(
                                        Icons.edit,
                                        color: GFColors.SUCCESS,
                                        size: 25,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 25),
                                  GestureDetector(
                                    onTap: () {
                                      MyDialogs.showcupertinoAlertDialog(
                                        context: context,
                                        title: "Delete Note",
                                        content:
                                            "The note will be permanently deleted. Are you sure?",
                                        onYes: () async {
                                          await DatabaseService(
                                                  id: snp.data!.id)
                                              .deleteNoteDocbyId(
                                                  id: widget.noteModel.id!);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          border: Border.all(
                                            color: GFColors.DANGER,
                                          )),
                                      child: const Icon(
                                        Icons.delete,
                                        color: GFColors.DANGER,
                                        size: 25,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            widget.noteModel.title!,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    color: darken(
                                        Color(widget.noteModel.color!), .5)),
                          ),
                          const Divider(),
                          Text(
                            DateFormat("yyyy-MM-dd  KK:mm:a")
                                .format(DateTime.parse(widget.noteModel.date!)),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                    // fontWeight: FontWeight.w900,
                                    color: darken(
                                        Color(widget.noteModel.color!), .5)),
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Text(
                                widget.noteModel.note!,
                                textAlign: TextAlign.justify,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        fontSize: 20, color: Colors.black),
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
          }),
    );
  }
}
