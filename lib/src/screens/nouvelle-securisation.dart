import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/MunitionReferenceEnum.dart';
import 'package:flutter_application/src/models/ParcelleModel.dart';
import 'package:flutter_application/src/models/PlanSondageModel.dart';
import 'package:flutter_application/src/models/SecurisationModel.dart';
import 'package:flutter_application/src/sqlite/SecurisationQuery.dart';
import 'package:flutter_application/src/widget/nouvelle-securisation-form-widget.dart';

class NouvelleSecurisation extends StatefulWidget {
  final ParcelleModel parcelle;

  const NouvelleSecurisation({required this.parcelle, Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _NouvelleSecurisationState();
}

class _NouvelleSecurisationState extends State<NouvelleSecurisation> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nom = TextEditingController();
  TextEditingController cotePlateforme = TextEditingController(text: "0.0");
  TextEditingController coteASecuriser = TextEditingController(text: "0.0");
  TextEditingController profondeurASecuriser =
      TextEditingController(text: "0.0");
  TextEditingController parcelle = TextEditingController();
  List<PlanSondageModel> _planSondages = [];
  MunitionReferenceEnum? _selectedMunitionReference;

  @override
  initState() {
    super.initState();
    parcelle.text = widget.parcelle.nom.toString();
  }

  @override
  void dispose() {
    nom.dispose();
    cotePlateforme.dispose();
    coteASecuriser.dispose();
    profondeurASecuriser.dispose();
    parcelle.dispose();
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
                parcelle: parcelle,
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
                          /*SecurisationRepository().addSecurisation(
                              context,
                              SecurisationModel(
                                  nom: nom.text,
                                  munitionReference:
                                      _selectedMunitionReference!,
                                  cotePlateforme:
                                      double.parse(cotePlateforme.text),
                                  profondeurASecuriser:
                                      double.parse(profondeurASecuriser.text),
                                  coteASecuriser:
                                      double.parse(coteASecuriser.text),
                                  parcelle: widget.parcelle.id),
                              widget.parcelle);*/
                          SecurisationQuery().addSecurisation(
                              SecurisationModel(
                                  nom: nom.text,
                                  munitionReference:
                                      _selectedMunitionReference!,
                                  cotePlateforme:
                                      double.parse(cotePlateforme.text),
                                  profondeurASecuriser:
                                      double.parse(profondeurASecuriser.text),
                                  coteASecuriser:
                                      double.parse(coteASecuriser.text),
                                  parcelle: widget.parcelle.id),
                              context);
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

  void updateCoteASecuriserValue() {
    String firstValue = cotePlateforme.text;
    String secondValue = profondeurASecuriser.text;

    if (firstValue.isEmpty || secondValue.isEmpty) {
      coteASecuriser.text = '';
      return;
    }

    double result = double.parse(firstValue) - double.parse(secondValue);
    coteASecuriser.text = result.toString();
    setState(() {});
  }
}
