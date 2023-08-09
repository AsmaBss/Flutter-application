import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/form-model.dart';
import 'package:flutter_application/src/repositories/form-repository.dart';
import 'package:json_to_form/json_schema.dart';

class FormExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FormExampleState();
}

class _FormExampleState extends State<FormExample> {
  FormModel? f;
  String fields = "";

  Map keyboardTypes = {
    "number": TextInputType.number,
  };
  String form = json.encode({
    "fields": [
      {
        //'key': 'input1',
        "type": "Input",
        "label": "Input",
        "placeholder": "Input",
        "value": "Input",
        "required": true
      },
      {
        //'key': 'tareatext1',
        'type': 'TextArea',
        'label': 'TareaText',
        'placeholder': "TextArea",
        'value': 'TextArea',
        'required': true
      },
      {
        //'key': 'date',
        'type': 'Date',
        'label': 'Date',
        'required': true
      },
      {
        'key': 'switch1',
        'type': 'Switch',
        'label': 'Switch test',
        'value': false,
      },
      {
        'key': 'radiobutton1',
        'type': 'RadioButton',
        'label': 'Radio Button',
        'value': 2,
        'items': [
          {
            'label': "product 1",
            'value': 1,
          },
          {
            'label': "product 2",
            'value': 2,
          },
          {
            'label': "product 3",
            'value': 3,
          }
        ]
      },
      {
        'key': 'checkbox1',
        'type': 'Checkbox',
        'label': 'Checkbox test',
        'items': [
          {
            'label': "product 1",
            'value': true,
          },
          {
            'label': "product 2",
            'value': false,
          },
          {
            'label': "product 3",
            'value': false,
          }
        ]
      },
      {
        'key': 'select1',
        'type': 'Select',
        'label': 'Select test',
        'value': 'product 1',
        'items': [
          {
            'label': "product 1",
            'value': "product 1",
          },
          {
            'label': "product 2",
            'value': "product 2",
          },
          {
            'label': "product 3",
            'value': "product 3",
          }
        ]
      }
    ]
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

  @override
  void initState() {
    _getForm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("test page"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: (f != null && f!.fields != null)
              ? Column(children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: Text(
                      utf8.decode(f!.titre!.codeUnits),
                      //"Test Form",
                      style: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: Text(
                      utf8.decode(f!.description!.codeUnits),
                      //"Test Form",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  JsonSchema(
                    decorations: decorations,
                    keyboardTypes: keyboardTypes,
                    form: utf8.decode(fields.codeUnits),
                    //form: form,
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
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ])
              : Text("no fields"),
        ),
      ),
    );
  }

  _getForm() async {
    print("testtt");
    f = await FormRepository().getById(1, context);
    fields = "{\"fields\": ${f!.fields}}";

    print(fields);
    setState(() {});
  }
}
