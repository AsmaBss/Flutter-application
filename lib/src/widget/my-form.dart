import 'package:flutter/material.dart';
import 'package:flutter_application/test.dart';
import 'package:geocoder/geocoder.dart';

class MyForm extends StatelessWidget {
  final TextEditingController description;
  final String address, latlong;
  final Widget textButton;
  final formKey;

  MyForm(
      {required this.formKey,
      required this.address,
      required this.latlong,
      required this.description,
      required this.textButton});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10.0),
            child: Text(
              address,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ),
          Text(latlong),
          TextFormField(
            controller: description,
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: 'Description',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: textButton,
          ),
        ],
      ),
    );
  }
}
