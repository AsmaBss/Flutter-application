import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/MunitionReferenceEnum.dart';
import 'package:number_inc_dec/number_inc_dec.dart';

class NouveauPasseFormWidget extends StatelessWidget {
  final formKey;
  final TextEditingController? profondeurSonde,
      gradient,
      coteSecurisee,
      profondeurSecurisee;
  final MunitionReferenceEnum? valueMunitionRef;
  final List<DropdownMenuItem<MunitionReferenceEnum>>? itemsMunitionRef;
  final onChangedDropdownMunitionRef;
  final Function(String)? onChangedProfondeurSecurisee;

  NouveauPasseFormWidget(
      {this.formKey,
      this.valueMunitionRef,
      this.itemsMunitionRef,
      this.onChangedDropdownMunitionRef,
      this.gradient,
      this.profondeurSonde,
      this.profondeurSecurisee,
      this.onChangedProfondeurSecurisee,
      this.coteSecurisee});

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
          Padding(
            padding: EdgeInsets.only(bottom: 15.0),
            child: TextFormField(
              controller: gradient,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Gradient Mag (nT)',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.green),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 15.0),
            child: TextFormField(
              controller: profondeurSonde,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                labelText: "Profondeur de la sonde",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.green),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez renseigner ce champ';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 15.0),
            child: TextFormField(
              controller: profondeurSecurisee,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                labelText: "Profondeur sécurisée (m)",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.green),
                ),
              ),
              onChanged: onChangedProfondeurSecurisee,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez renseigner ce champ';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 15.0),
            child: TextFormField(
              controller: coteSecurisee,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                labelText: "Côte sécurisée (m)",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.green),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez renseigner ce champ';
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
