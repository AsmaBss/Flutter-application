import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/MunitionReferenceEnum.dart';
import 'package:number_inc_dec/number_inc_dec.dart';

class NouveauPasseFormWidget extends StatelessWidget {
  final formKey;
  final MunitionReferenceEnum? valueMunitionRef;
  final List<DropdownMenuItem<MunitionReferenceEnum>>? itemsMunitionRef;
  final onChangedDropdownMunitionRef;
  final TextEditingController? profondeurSonde,
      gradient,
      coteSecurisee,
      profondeurSecurisee;
  final num? initialCoteSecurisee, initialProfondeurSecurisee;

  NouveauPasseFormWidget(
      {this.formKey,
      this.valueMunitionRef,
      this.itemsMunitionRef,
      this.onChangedDropdownMunitionRef,
      this.profondeurSonde,
      this.gradient,
      this.coteSecurisee,
      this.initialCoteSecurisee,
      this.profondeurSecurisee,
      this.initialProfondeurSecurisee});

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
            child: DropdownButtonFormField<MunitionReferenceEnum>(
              value: valueMunitionRef,
              hint: Text('Sélectionner une munition de référence'),
              items: itemsMunitionRef,
              onChanged: onChangedDropdownMunitionRef,
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
              controller: profondeurSonde!,
              initialValue: 0,
              //incDecFactor: 50,
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
              //initialValue: initialProfondeurSecurisee!,
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
              //initialValue: initialCoteSecurisee!,
            ),
          ),
        ],
      ),
    );
  }
}
