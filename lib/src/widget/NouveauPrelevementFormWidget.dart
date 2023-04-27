import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/PlanSondageModel.dart';

import '../database/images-query.dart';

class NouveauPrelevementFormWidget extends StatelessWidget {
  final formKey;
  final TextEditingController? numero,
      munitionRef,
      cotePlateforme,
      coteASecurise,
      profondeurASecurise,
      remarques;
  final List<DropdownMenuItem<PlanSondageModel>>? itemsPlanSondage;
  final onChangedDropdownPlanSondage;
  final PlanSondageModel? valuePlanSondage;
  final onPressedCam, onChangedStatut;
  final String? statut;
  final nvPasse;
  final Widget? imageGrid;

  NouveauPrelevementFormWidget(
      {this.formKey,
      this.numero,
      this.munitionRef,
      this.cotePlateforme,
      this.coteASecurise,
      this.profondeurASecurise,
      this.remarques,
      this.valuePlanSondage,
      this.itemsPlanSondage,
      this.onChangedDropdownPlanSondage,
      this.onPressedCam,
      this.onChangedStatut,
      this.statut,
      this.nvPasse,
      this.imageGrid});

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
              decoration: InputDecoration(
                labelText: "Numéro de prélèvement",
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
            child: DropdownButtonFormField<PlanSondageModel>(
              isExpanded: true,
              value: valuePlanSondage,
              hint: Text('Sélectionner un point de sondage'),
              items: itemsPlanSondage,
              onChanged: onChangedDropdownPlanSondage,
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
            padding: EdgeInsets.only(bottom: 15.0),
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
          Row(
            children: [
              Container(
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  height: 300,
                  width: 280,
                  child: imageGrid),
              /*Container(
                padding: EdgeInsets.only(top: 15, bottom: 15),
                height: 300,
                width: 280,
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  addAutomaticKeepAlives: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    childAspectRatio: 1,
                    mainAxisExtent: 170,
                  ),
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      color: Colors.blue,
                      child: Center(
                        child: Text(
                          'Item $index',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ),
              */
              IconButton(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerRight,
                onPressed: onPressedCam,
                icon: Icon(
                  Icons.camera_alt,
                  color: Colors.green,
                ),
              ),
            ],
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
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
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Radio(
                          value: "Sécurisé",
                          groupValue: statut,
                          onChanged: onChangedStatut,
                        ),
                        Expanded(
                          child: Text('Sécurisé'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Radio(
                          value: "A vérifier",
                          groupValue: statut,
                          onChanged: onChangedStatut,
                        ),
                        Expanded(
                          child: Text('A vérifier'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Radio(
                          value: "Non Sécurisé",
                          groupValue: statut,
                          onChanged: onChangedStatut,
                        ),
                        Expanded(
                          child: Text('Non sécurisé'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
