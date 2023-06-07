import 'package:flutter/material.dart';

class MyPopupMarker extends StatelessWidget {
  final void Function()? onPressed;

  MyPopupMarker({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /*Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            "${point.latitude}",
            overflow: TextOverflow.ellipsis,
            softWrap: false,
          ),
        ),*/
          TextButton(
            onPressed: onPressed,
            child: Text("Nouvelle Observation"),
          ),
        ],
      ),
    );
  }
}
