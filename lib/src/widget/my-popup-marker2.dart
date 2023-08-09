import 'package:flutter/material.dart';

class MyPopupMarker2 extends StatelessWidget {
  final String titre;
  final void Function()? onPressed;
  final String titre2;
  final void Function()? onPressed2;

  MyPopupMarker2(
      {required this.onPressed,
      required this.titre,
      required this.onPressed2,
      required this.titre2});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: onPressed,
            child: Text(titre),
          ),
          TextButton(
            onPressed: onPressed2,
            child: Text(titre2),
          ),
        ],
      ),
    );
  }
}
