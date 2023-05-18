import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/MunitionReferenceEnum.dart';
import 'package:flutter_application/src/models/ParcelleModel.dart';
import 'package:flutter_application/src/models/PlanSondageModel.dart';
import 'package:flutter_application/src/models/SecurisationModel.dart';
import 'package:flutter_application/src/repositories/ParcelleRepository.dart';
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
  TextEditingController cotePlateforme = TextEditingController();
  TextEditingController coteASecurise = TextEditingController();
  TextEditingController profondeurASecurise = TextEditingController();
  TextEditingController planSondage = TextEditingController();
  List<ParcelleModel> _parcelles = [];
  List<PlanSondageModel> _planSondages = [];
  ParcelleModel? _selectedParcelle;
  MunitionReferenceEnum? _selectedMunitionReference;
  num? initialCoteASecuriser;

  @override
  initState() {
    super.initState();
    _loadParcelles();
    initialCoteASecuriser =
        int.parse(cotePlateforme.text) - int.parse(profondeurASecurise.text);
  }

  @override
  void dispose() {
    nom.dispose();
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
              valueParcelle: _selectedParcelle,
              itemsParcelle: _parcelles.map((ParcelleModel parcelle) {
                return DropdownMenuItem<ParcelleModel>(
                  value: parcelle,
                  child: Text(parcelle.file!),
                );
              }).toList(),
              onChangedDropdownParcelle: (ParcelleModel newValue) {
                setState(() {
                  _selectedParcelle = newValue;
                  _loadPlanSondage(newValue);
                });
              },
              valueMunitionRef: _selectedMunitionReference,
              itemsMunitionRef: MunitionReferenceEnum.values
                  .map((value) => DropdownMenuItem(
                        value: value,
                        child: Text(value.sentence),
                      ))
                  .toList(),
              onChangedDropdownMunitionRef: (MunitionReferenceEnum newValue) {
                setState(() {
                  _selectedMunitionReference = newValue;
                });
              },
              cotePlateforme: cotePlateforme,
              profondeurASecuriser: profondeurASecurise,
              coteASecuriser: coteASecurise,
              planSondage: planSondage,
              initialCoteASecuriser: initialCoteASecuriser,
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
                                  nom: nom.text,
                                  munitionReference: _selectedMunitionReference,
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
                                )));
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
    setState(() {});
  }

  _loadPlanSondage(ParcelleModel parcelle) async {
    if (_selectedParcelle != "") {
      List<PlanSondageModel> list =
          await PlanSondageRepository().getPlanSondageByParcelle(parcelle.id!);
      _planSondages = list;
      planSondage.text = _planSondages.first.file!;
    }
  }
}
