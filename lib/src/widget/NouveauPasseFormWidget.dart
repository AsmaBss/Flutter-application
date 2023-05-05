import 'package:flutter/material.dart';
import 'package:number_inc_dec/number_inc_dec.dart';

class NouveauPasseFormWidget extends StatelessWidget {
  final formKey;
  final TextEditingController? munitionRef,
      coteSecurisee,
      profondeurSecurisee,
      gradient;
  final TextEditingController profondeurSonde;

  NouveauPasseFormWidget(
      {this.formKey,
      this.munitionRef,
      this.profondeurSecurisee,
      this.coteSecurisee,
      this.gradient,
      required this.profondeurSonde});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 15.0),
            child: TextFormField(
              controller: munitionRef,
              decoration: InputDecoration(
                labelText: 'Munition de référence',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.green),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),
          Text(
            "Profondeur de la sonde",
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 15.0),
            child: NumberInputPrefabbed.roundedEdgeButtons(
              controller: profondeurSonde,
              initialValue: 50,
              incDecFactor: 50,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 15.0),
            child: TextFormField(
              controller: gradient,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Gradient Mag (nT)',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.green),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),
          Text(
            "Profondeur sécurisée (m)",
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 15.0),
            child: NumberInputPrefabbed.roundedEdgeButtons(
              controller: profondeurSecurisee!,
              initialValue: 1,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),
          Text(
            "Côte sécurisée (m)",
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 15.0),
            child: NumberInputPrefabbed.roundedEdgeButtons(
              controller: coteSecurisee!,
              initialValue: 1,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
