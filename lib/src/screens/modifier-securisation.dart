import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/MunitionReferenceEnum.dart';
import 'package:flutter_application/src/models/ParcelleModel.dart';
import 'package:flutter_application/src/models/SecurisationModel.dart';
import 'package:flutter_application/src/sqlite/SecurisationQuery.dart';
import 'package:flutter_application/src/widget/nouvelle-securisation-form-widget.dart';

class ModifierSecurisation extends StatefulWidget {
  final SecurisationModel securisation;
  final ParcelleModel parcelle;

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
  TextEditingController parcelle = TextEditingController();
  MunitionReferenceEnum? _selectedMunitionReference;

  @override
  initState() {
    super.initState();
    nom.text = widget.securisation.nom.toString();
    _selectedMunitionReference = widget.securisation.munitionReference;
    cotePlateforme.text = widget.securisation.cotePlateforme.toString();
    profondeurASecuriser.text =
        widget.securisation.profondeurASecuriser.toString();
    coteASecuriser.text = widget.securisation.coteASecuriser.toString();
    parcelle.text = widget.parcelle.nom.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Modifier sécurisation \n${widget.securisation.nom}"),
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
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        /*SecurisationRepository().updateSecurisation(
                            context,
                            SecurisationModel(
                                id: widget.securisation.id,
                                nom: nom.text,
                                munitionReference: _selectedMunitionReference!,
                                cotePlateforme:
                                    double.parse(cotePlateforme.text),
                                profondeurASecuriser:
                                    double.parse(profondeurASecuriser.text),
                                coteASecuriser:
                                    double.parse(coteASecuriser.text),
                                parcelle: widget.parcelle.id),
                            widget.securisation.id!);*/
                        SecurisationQuery().updateSecurisation(
                            SecurisationModel(
                                id: widget.securisation.id,
                                nom: nom.text,
                                munitionReference: _selectedMunitionReference!,
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
