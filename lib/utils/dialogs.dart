import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
}
