import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
import '../screens/Home/note_page.dart';
import 'no_items_widget.dart';

class NotesListWidget extends StatelessWidget {
  const NotesListWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final List<NoteModel> notes = Provider.of<List<NoteModel>>(context);
    // var size = MediaQuery.of(context).size;

    // /*24 is for notification bar on Android*/
    // final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    // final double itemWidth = size.width / 2;
    return notes.isEmpty
        ? const EmptyListWidget()
        : GridView.count(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            primary: false,
            crossAxisCount: 2,
            childAspectRatio: 1,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            controller: ScrollController(keepScrollOffset: false),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: notes
                .map(
                  (e) => AnimatednoteItem(
                    note: e,
                    index: notes.indexOf(e),
                  ),
                )
                .toList(),
          );
    // : ListView.separated(
    //     itemBuilder: (context, index) =>
    //         AnimatednoteItem(note: notes[index], index: index),
    //     separatorBuilder: (context, index) => const Divider(),
    //     itemCount: notes.length);
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
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _animate ? 1 : 0,
      curve: Curves.easeInOutQuart,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 300),
        padding: _animate
            ? const EdgeInsets.all(4.0)
            : const EdgeInsets.only(top: 10),

        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (contextctx) => NotePage(noteModel: widget.note),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(widget.note.color!),
              borderRadius: BorderRadius.circular(15),
              // border: Border.all(
              //   color: Color(widget.note.color!).withOpacity(0.5),
              // ),
              boxShadow: [
                BoxShadow(
                  color: darken(Color(widget.note.color!), .5),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(2, 2), // changes position of shadow
                ),
              ],
            ),
            // Color(widget.note.color!)
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.note.title!,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: 17,
                      color: darken(Color(widget.note.color!), .5)),
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: Text(
                    widget.note.note!,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.black),
                    overflow: TextOverflow.fade,
                  ),
                ),
              ],
            ),
          ),
        ),
        //   child: Container(
        //     padding: const EdgeInsets.all(10),
        //     margin: const EdgeInsets.all(10),
        //     child: ExpandableNotifier(
        //       child: ExpandablePanel(
        //         theme: const ExpandableThemeData(
        //             iconPlacement: ExpandablePanelIconPlacement.left,
        //             iconPadding: EdgeInsets.only(top: 11)),
        //         collapsed: Text(
        //             widget.note.note!.substring(
        //                     0,
        //                     min(
        //                       widget.note.note!.length,
        //                       150,
        //                     )) +
        //                 (widget.note.note!.length >= 150 ? " ..." : ""),
        //             style: Theme.of(context).textTheme.bodyMedium),
        //         header: Padding(
        //           padding: const EdgeInsets.all(8.0),
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             children: [
        //               Text(
        //                 DateFormat("yyyy-MM-dd  kk:mm:a")
        //                     .format(DateTime.parse(widget.note.date!)),
        //                 style: Theme.of(context)
        //                     .textTheme
        //                     .titleSmall!
        //                     .copyWith(fontWeight: FontWeight.w900),
        //               ),
        //               Row(
        //                 children: [
        //                   GestureDetector(
        //                       onTap: () {
        //                         docModalShow(
        //                           context,
        //                           user.id!,
        //                           docId: widget.note.id,
        //                           initNote: widget.note.note!,
        //                         );
        //                       },
        //                       child: const Icon(Icons.edit_outlined,
        //                           color: Colors.green)),
        //                   const SizedBox(width: 10),
        //                   GestureDetector(
        //                     onTap: () async {
        //                       MyDialogs.showcupertinoAlertDialog(
        //                         context: context,
        //                         title: "Delete Note",
        //                         content:
        //                             "The note will be permanently deleted. Are you sure?",
        //                         onYes: () async {
        //                           Navigator.pop(context);
        //                           await DatabaseService(id: user.id)
        //                               .deleteNoteDocbyId(id: widget.note.id!);
        //                         },
        //                       );
        //                     },
        //                     child: const Icon(Icons.delete_forever,
        //                         color: Colors.red),
        //                   ),
        //                 ],
        //               )
        //             ],
        //           ),
        //         ),
        //         expanded: Text(widget.note.note!,
        //             style: Theme.of(context).textTheme.bodyMedium),
        //         controller: ExpandableController(initialExpanded: false),
        //       ),
        //     ),
        //   ),
      ),
    );
  }
}

Color darken(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

Color lighten(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

  return hslLight.toColor();
}
