import 'package:flutter/material.dart';

class EmptyListWidget extends StatelessWidget {
  const EmptyListWidget({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          image: const AssetImage("assets/sad-face.png"),
          width: MediaQuery.of(context).size.width / 1.5,
          height: MediaQuery.of(context).size.width / 1.5,
        ),
        const SizedBox(height: 20),
        Text(
          "No $text Found !",
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 26,
              ),
        ),
      ],
    ));
  }
}
