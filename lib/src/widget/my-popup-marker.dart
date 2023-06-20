import 'package:flutter/material.dart';

class MyPopupMarker extends StatelessWidget {
  final void Function()? onPressed;
  final String titre;

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
