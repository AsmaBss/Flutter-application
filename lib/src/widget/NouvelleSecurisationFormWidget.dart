import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/ParcelleModel.dart';
import 'package:number_inc_dec/number_inc_dec.dart';

class NouvelleSecurisationFormWidget extends StatelessWidget {
  final formKey;
  final TextEditingController? nom,
      munitionRef,
      cotePlateforme,
      coteASecurise,
      profondeurASecurise,
      planSondage;
  final List<DropdownMenuItem<ParcelleModel>>? items;
  final onChangedDropdown;
  final ParcelleModel? value;

  NouvelleSecurisationFormWidget({
    this.formKey,
    this.items,
    this.nom,
    this.munitionRef,
    this.cotePlateforme,
    this.coteASecurise,
    required this.profondeurASecurise,
    this.onChangedDropdown,
    this.value,
    this.planSondage,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 15.0),
            child: TextFormField(
              controller: nom,
              decoration: InputDecoration(
                labelText: "Nom de la sécurisation",
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
          Padding(
            padding: EdgeInsets.only(bottom: 15.0),
            child: DropdownButtonFormField<ParcelleModel>(
              value: value,
              hint: Text('Sélectionner une parcelle'),
              items: items,
              onChanged: onChangedDropdown,
            ),
          ),
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
          Padding(
            padding: EdgeInsets.only(bottom: 15.0),
            child: TextFormField(
              controller: cotePlateforme,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Côte de la plateforme',
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
            "Profondeur à sécuriser (m)",
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 15.0),
            child: NumberInputPrefabbed.roundedEdgeButtons(
              controller: profondeurASecurise!,
              initialValue: 9,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),
          Text(
            "Côte à sécuriser (m)",
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 15.0),
            child: NumberInputPrefabbed.roundedEdgeButtons(
              controller: coteASecurise!,
              initialValue: 9,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 15.0),
            child: TextFormField(
              controller: planSondage,
              decoration: InputDecoration(
                hintText: 'Plan de sondage sélectionné',
                labelText: 'Plan de sondage sélectionné',
              ),
              readOnly: true,
            ),
          ),
        ],
      ),
    );
  }
}
