import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/MunitionReferenceEnum.dart';
import 'package:flutter_application/src/models/ParcelleModel.dart';
import 'package:flutter_application/src/models/PlanSondageModel.dart';
import 'package:flutter_application/src/models/SecurisationModel.dart';
import 'package:flutter_application/src/repositories/ParcelleRepository.dart';
import 'package:flutter_application/src/repositories/PlanSondageRepository.dart';
import 'package:flutter_application/src/widget/nouvelle-securisation-form-widget.dart';

import '../repositories/SecurisationRepository.dart';

class ModifierSecurisation extends StatefulWidget {
  final SecurisationModel securisation;
  final ParcelleModel? parcelle;

  const ModifierSecurisation(
      {required this.securisation, required this.parcelle, Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ModifierSecurisationState();
}

class _ModifierSecurisationState extends State<ModifierSecurisation> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nom = TextEditingController();
  TextEditingController cotePlateforme = TextEditingController();
  TextEditingController coteASecuriser = TextEditingController();
  TextEditingController profondeurASecuriser = TextEditingController();
  TextEditingController planSondage = TextEditingController();
  List<ParcelleModel> _parcelles = [];
  ParcelleModel? _selectedParcelle;
  List<PlanSondageModel> _planSondages = [];
  MunitionReferenceEnum? _selectedMunitionReference;

  @override
  initState() {
    super.initState();
    nom.text = widget.securisation.nom.toString();
    _loadParcelles();
    _selectedMunitionReference = widget.securisation.munitionReference;
    cotePlateforme.text = widget.securisation.cotePlateforme.toString();
    profondeurASecuriser.text =
        widget.securisation.profondeurASecuriser.toString();
    coteASecuriser.text = widget.securisation.coteASecuriser.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Modifier sécurisation - \n${widget.securisation.nom}"),
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
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        SecurisationRepository().updateSecurisation(
                            context,
                            SecurisationModel(
                              nom: nom.text,
                              munitionReference: _selectedMunitionReference,
                              cotePlateforme: int.parse(cotePlateforme.text),
                              profondeurASecuriser:
                                  int.parse(profondeurASecuriser.text),
                              coteASecuriser: int.parse(coteASecuriser.text),
                            ),
                            widget.securisation.id!);
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
    _parcelles
        .map((ParcelleModel e) => {
              if (e.toString() == widget.parcelle.toString())
                {_selectedParcelle = e, _loadPlanSondage(_selectedParcelle!)}
            })
        .toList();
    setState(() {});
  }

  _loadPlanSondage(ParcelleModel parcelle) async {
    if (_selectedParcelle != "") {
      List<PlanSondageModel> list =
          await PlanSondageRepository().getPlanSondageByParcelle(parcelle.id!);
      _planSondages = list;
      planSondage.text = _planSondages.first.nom!;
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
