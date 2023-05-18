import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/MunitionReferenceEnum.dart';
import 'package:flutter_application/src/models/ParcelleModel.dart';
import 'package:number_inc_dec/number_inc_dec.dart';

class NouvelleSecurisationFormWidget extends StatelessWidget {
  final formKey;
  final TextEditingController? nom,
      cotePlateforme,
      coteASecuriser,
      profondeurASecuriser,
      planSondage;
  final ParcelleModel? valueParcelle;
  final MunitionReferenceEnum? valueMunitionRef;
  final List<DropdownMenuItem<ParcelleModel>>? itemsParcelle;
  final List<DropdownMenuItem<MunitionReferenceEnum>>? itemsMunitionRef;
  final onChangedDropdownParcelle, onChangedDropdownMunitionRef;
  final num? initialCoteASecuriser; //initialProfondeurASecuriser,
  //initialCotePlateforme;

  NouvelleSecurisationFormWidget({
    this.formKey,
    this.nom,
    this.valueParcelle,
    this.itemsParcelle,
    this.onChangedDropdownParcelle,
    this.valueMunitionRef,
    this.itemsMunitionRef,
    this.onChangedDropdownMunitionRef,
    this.cotePlateforme,
    this.coteASecuriser,
    this.profondeurASecuriser,
    this.planSondage,
    //this.initialCotePlateforme,
    //this.initialProfondeurASecuriser,
    this.initialCoteASecuriser,
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
                  return 'Veuillez renseigner ce champ';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 15.0),
            child: DropdownButtonFormField<ParcelleModel>(
              value: valueParcelle,
              hint: Text('Sélectionner un lot'),
              items: itemsParcelle,
              onChanged: onChangedDropdownParcelle,
              validator: (value) {
                if (value == null || value == "") {
                  return 'Veuillez renseigner ce champ';
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 15.0),
            child: DropdownButtonFormField<MunitionReferenceEnum>(
              value: valueMunitionRef,
              hint: Text('Sélectionner une munition de référence'),
              items: itemsMunitionRef,
              onChanged: onChangedDropdownMunitionRef,
              validator: (value) {
                if (value == null || value == "") {
                  return 'Veuillez renseigner ce champ';
                }
              },
            ),
          ),
          Text(
            "Côte de la plateforme",
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 15.0),
            child: NumberInputPrefabbed.roundedEdgeButtons(
              controller: cotePlateforme!,
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
              controller: profondeurASecuriser!,
              //initialValue: initialProfondeurASecuriser ?? 0,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez renseigner ce champ';
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
              controller: coteASecuriser!,
              initialValue: initialCoteASecuriser ?? 0,
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
