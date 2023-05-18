import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/MunitionReferenceEnum.dart';
import 'package:flutter_application/src/models/StatutEnum.dart';
import 'package:number_inc_dec/number_inc_dec.dart';

class NouveauPrelevementFormWidget extends StatelessWidget {
  final formKey;
  final TextEditingController? numero,
      cotePlateforme,
      coteASecurise,
      profondeurASecurise,
      remarques;
  final MunitionReferenceEnum? valueMunitionRef;
  final List<DropdownMenuItem<MunitionReferenceEnum>>? itemsMunitionRef;
  final onChangedDropdownMunitionRef;
  final num? initialProfondeurASecuriser,
      initialCoteASecuriser,
      initialCotePlateforme;
  final onPressedCam, onChangedStatut;
  final StatutEnum? selectedStatut;
  final nvPasse;
  final Widget? imageGrid, listPasse;

  NouveauPrelevementFormWidget(
      {this.formKey,
      this.numero,
      this.valueMunitionRef,
      this.itemsMunitionRef,
      this.onChangedDropdownMunitionRef,
      this.cotePlateforme,
      this.initialCotePlateforme,
      this.coteASecurise,
      this.initialCoteASecuriser,
      this.profondeurASecurise,
      this.initialProfondeurASecuriser,
      this.remarques,
      this.onPressedCam,
      this.onChangedStatut,
      this.selectedStatut,
      this.nvPasse,
      this.imageGrid,
      this.listPasse});

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
              controller: numero,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Numéro de prélèvement",
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
            child: DropdownButtonFormField<MunitionReferenceEnum>(
              value: valueMunitionRef,
              hint: Text('Sélectionner une munition de référence'),
              items: itemsMunitionRef,
              onChanged: onChangedDropdownMunitionRef,
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
              initialValue: initialCotePlateforme!,
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
              initialValue: initialProfondeurASecuriser!,
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
              initialValue: initialCoteASecuriser!,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 15.0),
            child: TextFormField(
              controller: remarques,
              keyboardType: TextInputType.multiline,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Remarques',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.green),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Images",
                  style: TextStyle(color: Colors.grey[700], fontSize: 16),
                ),
                IconButton(
                  color: Colors.green,
                  onPressed: onPressedCam,
                  icon: Icon(Icons.camera_alt, size: 24),
                ),
              ],
            ),
          ),
          Container(
            height: 300,
            padding: EdgeInsets.only(bottom: 15.0),
            child: imageGrid,
          ),
          Container(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Passe",
                  style: TextStyle(color: Colors.grey[700], fontSize: 16),
                ),
                IconButton(
                  color: Colors.green,
                  onPressed: nvPasse,
                  icon: Icon(Icons.add, size: 24),
                ),
              ],
            ),
          ),
          Container(
            height: 300,
            padding: EdgeInsets.only(bottom: 15.0),
            child: listPasse,
          ),
          Text(
            "Statut",
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
            ),
          ),
          Column(
            children: [
              Row(
                children: StatutEnum.values
                    .map(
                      (statut) => Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            Radio(
                              value: statut,
                              groupValue: selectedStatut,
                              onChanged: onChangedStatut,
                            ),
                            Expanded(
                              child: Text(statut.sentence),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
