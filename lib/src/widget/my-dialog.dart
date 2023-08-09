import 'package:flutter/material.dart';

class MyDialog extends StatelessWidget {
  final void Function()? onPressed;
  MyDialog({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Veuillez confirmer'),
      content: Text('Vous êtes sûr ?'),
      actions: [
        TextButton(
          onPressed: onPressed,
          child: const Text('Oui'),
        ),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Non'))
      ],
    );
  }
}
