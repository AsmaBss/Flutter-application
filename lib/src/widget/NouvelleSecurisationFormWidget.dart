import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/parcelle-model.dart';

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

  NouvelleSecurisationFormWidget(
      {this.formKey,
      this.items,
      this.nom,
      this.munitionRef,
      this.cotePlateforme,
      this.coteASecurise,
      this.profondeurASecurise,
      this.onChangedDropdown,
      this.value,
      this.planSondage});

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
          Padding(
            padding: EdgeInsets.only(bottom: 15.0),
            child: TextFormField(
              controller: profondeurASecurise,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Profondeur à sécuriser (m)',
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
            padding: EdgeInsets.only(bottom: 10.0),
            child: TextFormField(
              controller: coteASecurise,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Côte à sécuriser (m)',
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