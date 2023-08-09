import 'package:flutter/material.dart';

class MyPopupMarker extends StatelessWidget {
  final String titre;
  final void Function()? onPressed;

  MyPopupMarker({required this.onPressed, required this.titre});

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
        ],
      ),
    );
  }
}
