import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/MunitionReferenceEnum.dart';
import 'package:flutter_application/src/models/ParcelleModel.dart';
import 'package:flutter_application/src/models/PlanSondageModel.dart';
import 'package:flutter_application/src/models/SecurisationModel.dart';
import 'package:flutter_application/src/repositories/parcelle-repository.dart';
import 'package:flutter_application/src/repositories/plan-sondage-repository.dart';
import 'package:flutter_application/src/screens/map-prelevement.dart';
import 'package:flutter_application/src/widget/nouvelle-securisation-form-widget.dart';

import '../repositories/securisation-repository.dart';

class NouvelleSecurisation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NouvelleSecurisationState();
}

class _NouvelleSecurisationState extends State<NouvelleSecurisation> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nom = TextEditingController();
  TextEditingController cotePlateforme = TextEditingController(text: "0");
  TextEditingController coteASecuriser = TextEditingController(text: "0");
  TextEditingController profondeurASecuriser = TextEditingController(text: "0");
  TextEditingController planSondage = TextEditingController();
  List<ParcelleModel> _parcelles = [];
  ParcelleModel? _selectedParcelle;
  List<PlanSondageModel> _planSondages = [];
  MunitionReferenceEnum? _selectedMunitionReference;

  @override
  initState() {
    super.initState();
    _loadParcelles();
  }

  @override
  void dispose() {
    nom.dispose();
    cotePlateforme.dispose();
    coteASecuriser.dispose();
    profondeurASecuriser.dispose();
    planSondage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text("Nouvelle Sécurisation"),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
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
                    child: Text(parcelle.nom!),
                  );
                }).toList(),
                onChangedDropdownParcelle: (newValue) {
                  setState(() {
                    _selectedParcelle = newValue;
                    _loadPlanSondage(_selectedParcelle!);
                  });
                },
                valueMunitionRef: _selectedMunitionReference,
                itemsMunitionRef: MunitionReferenceEnum.values
                    .map((value) => DropdownMenuItem(
                          value: value,
                          child: Text(value.sentence),
                        ))
                    .toList(),
                onChangedDropdownMunitionRef: (newValue) {
                  setState(() {
                    _selectedMunitionReference = newValue;
                  });
                },
                cotePlateforme: cotePlateforme,
                onChangedCotePlateforme: (value) => updateCoteASecuriserValue(),
                profondeurASecuriser: profondeurASecuriser,
                onChangedProfondeurASecuriser: (value) =>
                    updateCoteASecuriserValue(),
                coteASecuriser: coteASecuriser,
                planSondage: planSondage,
              ),
              Padding(
                padding: EdgeInsets.all(40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Annuler"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          SecurisationModel? securisation =
                              await SecurisationRepository().addSecurisation(
                                  context,
                                  SecurisationModel(
                                      nom: nom.text,
                                      munitionReference:
                                          _selectedMunitionReference!,
                                      cotePlateforme:
                                          int.parse(cotePlateforme.text),
                                      profondeurASecuriser:
                                          int.parse(profondeurASecuriser.text),
                                      coteASecuriser:
                                          int.parse(coteASecuriser.text)),
                                  _selectedParcelle!);
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => MapPrelevement(
                                  planSondage: _planSondages,
                                  securisation: securisation!,
                                  parcelle: _selectedParcelle!,
                                  leading: false)));
                        }
                      },
                      child: Text("Enregistrer"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _loadParcelles() async {
    await ParcelleRepository().getAllParcelles(context).then((value) {
      _parcelles = value!;
    });
    setState(() {});
  }

  _loadPlanSondage(ParcelleModel parcelle) async {
    if (_selectedParcelle != "") {
      await PlanSondageRepository()
          .getByParcelle(parcelle.id!, context)
          .then((value) {
        _planSondages = value!;
        planSondage.text = _planSondages.first.nom!;
      });
    }
  }

  void updateCoteASecuriserValue() {
    String firstValue = cotePlateforme.text;
    String secondValue = profondeurASecuriser.text;

    if (firstValue.isEmpty || secondValue.isEmpty) {
      coteASecuriser.text = '';
      return;
    }

    int result = int.parse(firstValue) - int.parse(secondValue);
    coteASecuriser.text = result.toString();
    setState(() {});
  }
}
