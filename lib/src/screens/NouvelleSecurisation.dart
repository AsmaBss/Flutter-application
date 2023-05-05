import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/ParcelleModel.dart';
import 'package:flutter_application/src/models/PlanSondageModel.dart';
import 'package:flutter_application/src/models/SecurisationModel.dart';
import 'package:flutter_application/src/repositories/parcelle-repository.dart';
import 'package:flutter_application/src/repositories/plan-sondage-repository.dart';
import 'package:flutter_application/src/screens/MapPrelevement.dart';
import 'package:flutter_application/src/widget/NouvelleSecurisationFormWidget.dart';

import '../repositories/SecurisationRepository.dart';

class NouvelleSecurisation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NouvelleSecurisationState();
}

class _NouvelleSecurisationState extends State<NouvelleSecurisation> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nom = TextEditingController();
  TextEditingController munitionRef = TextEditingController();
  TextEditingController cotePlateforme = TextEditingController();
  TextEditingController coteASecurise = TextEditingController();
  TextEditingController profondeurASecurise = TextEditingController();
  TextEditingController planSondage = TextEditingController();
  List<ParcelleModel> _parcelles = [];
  List<PlanSondageModel> _planSondages = [];
  ParcelleModel? _selectedParcelle;

  @override
  initState() {
    super.initState();
    _loadParcelles();
  }

  @override
  void dispose() {
    nom.dispose();
    munitionRef.dispose();
    cotePlateforme.dispose();
    coteASecurise.dispose();
    profondeurASecurise.dispose();
    planSondage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Nouvelle Sécurisation"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(30.0),
        child: Column(
          children: [
            NouvelleSecurisationFormWidget(
              formKey: _formKey,
              nom: nom,
              value: _selectedParcelle,
              items: _parcelles.map((ParcelleModel parcelle) {
                return DropdownMenuItem<ParcelleModel>(
                  value: parcelle,
                  child: Text(parcelle.file!),
                );
              }).toList(),
              onChangedDropdown: (ParcelleModel newValue) {
                setState(() {
                  _selectedParcelle = newValue;
                  _loadPlanSondage(newValue);
                });
              },
              munitionRef: munitionRef,
              cotePlateforme: cotePlateforme,
              profondeurASecurise: profondeurASecurise,
              coteASecurise: coteASecurise,
              planSondage: planSondage,
            ),
            Padding(
              padding: EdgeInsets.all(40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        SecurisationModel securisation =
                            await SecurisationRepository().addSecurisation(
                                context,
                                SecurisationModel(
                                  munitionReference: munitionRef.text,
                                  nom: nom.text,
                                  coteASecuriser: int.parse(coteASecurise.text),
                                  cotePlateforme:
                                      int.parse(cotePlateforme.text),
                                  profondeurASecuriser:
                                      int.parse(profondeurASecurise.text),
                                ),
                                _selectedParcelle!);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => MapPrelevement(
                                planSondage: _planSondages,
                                securisation: securisation,
                                parcelle: _selectedParcelle,
                                leading: false)));
                      }
                    },
                    child: Text("Enregistrer"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Annuler"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _loadParcelles() async {
    List<ParcelleModel> list =
        await ParcelleRepository().getAllParcelles(context);
    _parcelles = list;
    //_parcelles.map((ParcelleModel e) => {print(e.id)}).toList();
    setState(() {});
  }

  _loadPlanSondage(ParcelleModel parcelle) async {
    if (_selectedParcelle != "") {
      List<PlanSondageModel> list = await PlanSondageRepository()
          .getPlanSondageByParcelle(parcelle.id!, context);
      _planSondages = list;
      planSondage.text = _planSondages.first.file!;
    }
  }
}
