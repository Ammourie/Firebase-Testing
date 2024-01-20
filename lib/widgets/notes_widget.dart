import 'dart:math';

import 'package:expandable/expandable.dart';
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
      child: ListView.separated(
          itemBuilder: (context, index) => Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(10),
                child: ExpandablePanel(
                  theme: const ExpandableThemeData(
                      iconPlacement: ExpandablePanelIconPlacement.left,
                      iconPadding: EdgeInsets.only(top: 11)),
                  collapsed: Text(
                      notes[index].note!.substring(
                              0,
                              min(
                                notes[index].note!.length,
                                150,
                              )) +
                          (notes[index].note!.length >= 150 ? " ..." : ""),
                      style: Theme.of(context).textTheme.bodyMedium),
                  header: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat("yyyy-MM-dd  kk:mm:a")
                              .format(DateTime.parse(notes[index].date!)),
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontWeight: FontWeight.w900),
                        ),
                        const Row(
                          children: [
                            Icon(Icons.edit_outlined, color: Colors.green),
                            SizedBox(width: 10),
                            Icon(Icons.delete_forever, color: Colors.red),
                          ],
                        )
                      ],
                    ),
                  ),
                  expanded: Text(notes[index].note!,
                      style: Theme.of(context).textTheme.bodyMedium),
                  controller: ExpandableController(initialExpanded: false),
                ),
              ),
          separatorBuilder: (context, index) => const Divider(),
          itemCount: notes.length),
    );
  }
}
