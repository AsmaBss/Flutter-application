import 'package:flutter/material.dart';

class MyDialog extends StatelessWidget {
  final onPressed;
  MyDialog({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Veuillez confirmer'),
      content: Text('Vous êtes sûr de supprimer ?'),
      actions: [
        TextButton(onPressed: onPressed, child: const Text('Yes')),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'))
      ],
    );
  }
}
