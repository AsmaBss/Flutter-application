import 'package:flutter/material.dart';

import '../models/ParcelleModel.dart';

class FormWidget extends StatelessWidget {
  final Key? formKey;
  final TextEditingController? nom,
      munitionRef,
      cotePlateforme,
      coteASecurise,
      profondeurASecurise,
      planSondage;
  final String? nomText;
  final List<DropdownMenuItem<ParcelleModel>>? items;
  final void Function(ParcelleModel?)? onChangedDropdown;
  final ParcelleModel? value;

  FormWidget(
      {this.formKey,
      this.items,
      this.nom,
      this.nomText,
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            controller: nom,
            decoration: InputDecoration(
              labelText: nomText,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          DropdownButtonFormField<ParcelleModel>(
            value: value,
            hint: Text('Sélectionner'),
            items: items,
            onChanged: onChangedDropdown,
          ),
          TextFormField(
            controller: munitionRef,
            decoration: InputDecoration(
              labelText: 'Munition de référence',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          TextFormField(
            controller: cotePlateforme,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Côte de la plateforme',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          TextFormField(
            controller: profondeurASecurise,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Profondeur à sécuriser (m)',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          TextFormField(
            controller: coteASecurise,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Côte à sécuriser (m)',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          TextFormField(
            controller: planSondage,
            decoration: InputDecoration(
              hintText: 'Plan de sondage sélectionné',
              labelText: 'Plan de sondage sélectionné',
            ),
            readOnly: true,
          )
        ],
      ),
    );
  }
}
