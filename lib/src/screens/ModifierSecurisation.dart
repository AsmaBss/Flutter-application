import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/ParcelleModel.dart';
import 'package:flutter_application/src/models/PlanSondageModel.dart';
import 'package:flutter_application/src/models/SecurisationModel.dart';
import 'package:flutter_application/src/repositories/parcelle-repository.dart';
import 'package:flutter_application/src/repositories/plan-sondage-repository.dart';
import 'package:flutter_application/src/widget/NouvelleSecurisationFormWidget.dart';

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
  TextEditingController munitionRef = TextEditingController();
  TextEditingController cotePlateforme = TextEditingController();
  TextEditingController coteASecuriser = TextEditingController();
  TextEditingController profondeurASecuriser = TextEditingController();
  TextEditingController planSondage = TextEditingController();
  List<ParcelleModel> _parcelles = [];
  List<PlanSondageModel> _planSondages = [];
  ParcelleModel? _selectedParcelle;

  @override
  initState() {
    super.initState();
    _loadParcelles();
    nom.text = widget.securisation.nom.toString();
    munitionRef.text = widget.securisation.munitionReference.toString();
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
        title: Text("Modifier sécurisation  -  ${widget.securisation.nom}"),
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
              profondeurASecuriser: profondeurASecuriser,
              coteASecuriser: coteASecuriser,
              planSondage: planSondage,
              initialCoteASecuriser: widget.securisation.coteASecuriser,
              initialProfondeurASecuriser:
                  widget.securisation.profondeurASecuriser,
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
                              munitionReference: munitionRef.text,
                              nom: nom.text,
                              coteASecuriser: int.parse(coteASecuriser.text),
                              cotePlateforme: int.parse(cotePlateforme.text),
                              profondeurASecuriser:
                                  int.parse(profondeurASecuriser.text),
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
      planSondage.text = _planSondages.first.file!;
    }
  }
}
