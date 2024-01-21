import 'dart:math';

import 'package:expandable/expandable.dart';
import 'package:fb_testing/models/user.dart';
import 'package:fb_testing/screens/Home/home_screen.dart';
import 'package:fb_testing/services/database_service.dart';
import 'package:fb_testing/utils/dialogs.dart';
import 'package:fb_testing/widgets/no_items_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';

class NotesListWidget extends StatelessWidget {
  const NotesListWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final List<NoteModel> notes = Provider.of<List<NoteModel>>(context);

    return ExpandableNotifier(
      child: notes.isEmpty
          ? const EmptyListWidget()
          : ListView.separated(
              itemBuilder: (context, index) =>
                  AnimatednoteItem(note: notes[index], index: index),
              separatorBuilder: (context, index) => const Divider(),
              itemCount: notes.length),
    );
  }
}

class AnimatednoteItem extends StatefulWidget {
  final int index;
  const AnimatednoteItem({
    super.key,
    required this.note,
    required this.index,
  });

  final NoteModel note;

  @override
  State<AnimatednoteItem> createState() => _AnimatednoteItemState();
}

class _AnimatednoteItemState extends State<AnimatednoteItem> {
  bool _animate = false;

  static bool _isStart = true;

  @override
  void initState() {
    super.initState();
    if (_isStart) {
      Future.delayed(Duration(milliseconds: widget.index * 100), () {
        setState(() {
          _animate = true;
          _isStart = false;
        });
      });
    } else {
      _animate = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserModel>(context);

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _animate ? 1 : 0,
      curve: Curves.easeInOutQuart,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 300),
        padding: _animate
            ? const EdgeInsets.all(4.0)
            : const EdgeInsets.only(top: 10),
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          child: ExpandablePanel(
            theme: const ExpandableThemeData(
                iconPlacement: ExpandablePanelIconPlacement.left,
                iconPadding: EdgeInsets.only(top: 11)),
            collapsed: Text(
                widget.note.note!.substring(
                        0,
                        min(
                          widget.note.note!.length,
                          150,
                        )) +
                    (widget.note.note!.length >= 150 ? " ..." : ""),
                style: Theme.of(context).textTheme.bodyMedium),
            header: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat("yyyy-MM-dd  kk:mm:a")
                        .format(DateTime.parse(widget.note.date!)),
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontWeight: FontWeight.w900),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            docModalShow(
                              context,
                              user.id!,
                              docId: widget.note.id,
                              initNote: widget.note.note!,
                            );
                          },
                          child: const Icon(Icons.edit_outlined,
                              color: Colors.green)),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () async {
                          MyDialogs.showcupertinoAlertDialog(
                            context: context,
                            title: "Delete Note",
                            content:
                                "The note will be permanently deleted. Are you sure?",
                            onYes: () async {
                              Navigator.pop(context);
                              await DatabaseService(id: user.id)
                                  .deleteDocbyId(id: widget.note.id!);
                            },
                          );
                        },
                        child:
                            const Icon(Icons.delete_forever, color: Colors.red),
                      ),
                    ],
                  )
                ],
              ),
            ),
            expanded: Text(widget.note.note!,
                style: Theme.of(context).textTheme.bodyMedium),
            controller: ExpandableController(initialExpanded: false),
          ),
        ),
      ),
    );
  }
}
