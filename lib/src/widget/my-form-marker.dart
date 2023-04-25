import 'package:flutter/material.dart';

class MyFormMarker extends StatelessWidget {
  final Widget title;
  final Widget content;
  final List<Widget> actions;

  MyFormMarker(
      {required this.title, required this.content, this.actions = const []});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      insetPadding: EdgeInsets.all(20),
      //contentPadding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      title: title,
      content: content,
      actions: actions,
    );
  }
}
