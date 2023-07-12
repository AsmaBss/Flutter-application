import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/form-model.dart';
import 'package:flutter_application/src/repositories/form-repository.dart';
import 'package:json_to_form/json_schema.dart';

class FormExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FormExampleState();
}

class _FormExampleState extends State<FormExample> {
  Map keyboardTypes = {
    "number": TextInputType.number,
  };
  String form = json.encode({
    'fields': [
      {
        "type": "Input",
        "label": "text 1",
        "required": true,
        "placeholder": "text1"
      },
      {
        "type": "Input",
        "label": "text2",
        "required": false,
        "placeholder": "text2"
      },
      {
        "type": "TextArea",
        "label": "note1",
        "required": true,
        "placeholder": "note1"
      }
    ]
    /*'fields': [
      {
        'type': 'Text',
        'label': 'Name',
        'placeholder': "Enter Your Name",
        'required': true,
      },
      {
        'type': 'Input',
        'label': 'Username',
        'placeholder': "Enter Your Username",
        'required': true,
        'hiddenLabel': true,
      },
      {'type': 'Email', 'label': 'email', 'required': true},
      {'type': 'Password', 'label': 'Password', 'required': true},
      {'type': 'Input', 'label': 'number', 'required': true},
    ]*/
  });

  dynamic response;

  Map decorations = {
    'email': InputDecoration(
      hintText: 'Email',
      prefixIcon: const Icon(Icons.email),
      contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
    ),
    'username': const InputDecoration(
      labelText: "Enter your email",
      prefixIcon: Icon(Icons.account_box),
      border: OutlineInputBorder(),
    ),
    'password1': const InputDecoration(
        prefixIcon: Icon(Icons.security), border: OutlineInputBorder()),
  };

  FormModel? myForm;
  String? fields;
  //String form = json.encode({'fields': []});

  @override
  void initState() {
    _getForm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Form Example"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 10.0),
              child: Text(
                myForm != null ? myForm!.titre.toString() : '',
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0),
              child: Text(
                myForm != null ? myForm!.description.toString() : '',
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              ),
            ),
            JsonSchema(
              decorations: decorations,
              keyboardTypes: keyboardTypes,
              form: form,
              onChanged: (dynamic response) {
                print(jsonEncode(response));
                this.response = response;
              },
              actionSave: (data) {
                print(data);
              },
              buttonSave: Container(
                height: 40.0,
                color: Colors.blueAccent,
                child: const Center(
                  child: Text("Register",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  _getForm() async {
    myForm = await FormRepository().getById(3, context);
    print("---> $myForm");
    fields = "{\"fields\": ${myForm!.fields}}";
    form = json.encode({'fields': myForm!.fields});
    print(fields);
    setState(() {});
  }
}
