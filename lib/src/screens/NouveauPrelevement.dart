import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/plan-sondage-model.dart';
import 'package:flutter_application/src/screens/CameraPage.dart';
import 'package:flutter_application/src/screens/NouveauPasse.dart';
import 'package:flutter_application/src/widget/NouveauPrelevementFormWidget.dart';

class NouveauPrelevement extends StatefulWidget {
  final PlanSondageModel? planSondage;
  const NouveauPrelevement({this.planSondage, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NouveauPrelevementState();
}

class _NouveauPrelevementState extends State<NouveauPrelevement> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nom = TextEditingController();
  TextEditingController munitionRef = TextEditingController();
  TextEditingController cotePlateforme = TextEditingController();
  TextEditingController coteASecurise = TextEditingController();
  TextEditingController profondeurASecurise = TextEditingController();
  List<String> _coordinates = [];
  String? _selectedSondage;
  String? statut;

  @override
  initState() {
    super.initState();
    _loadSondages();
  }

  @override
  void dispose() {
    nom.dispose();
    munitionRef.dispose();
    cotePlateforme.dispose();
    coteASecurise.dispose();
    profondeurASecurise.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Nouveau Prélèvement"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(30.0),
        child: Column(
          children: [
            NouveauPrelevementFormWidget(
              formKey: _formKey,
              nom: nom,
              munitionRef: munitionRef,
              valuePlanSondage: _selectedSondage,
              itemsPlanSondage: _coordinates.map((coordinate) {
                return DropdownMenuItem<String>(
                  value: coordinate,
                  child: Text(coordinate),
                );
              }).toList(),
              onChangedDropdownPlanSondage: (selectedCoordinate) {
                setState(() {
                  _selectedSondage = selectedCoordinate;
                });
              },
              cotePlateforme: cotePlateforme,
              profondeurASecurise: profondeurASecurise,
              coteASecurise: coteASecurise,
              onPressedCam: () => _launchCamera(),
              statut: statut,
              onChangedStatut: (value) => {
                print('radio selected : ${value.toString()}'),
                setState(() {
                  statut = value.toString();
                })
                // what can i do here to get the value of the radio selected
              },
              nvPasse: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => NouveauPasse()));
              },
            ),
            Padding(
              padding: EdgeInsets.all(40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                NouveauPrelevement()));
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

  _loadSondages() async {
    print("load sondages");
    List<String> sondages = widget.planSondage!.geometry
        .toString()
        .replaceAll("MULTIPOINT (", "")
        .replaceAll("))", ")")
        .split(", ")
        .toList();
    print('sondages : $sondages');
    _coordinates = sondages.map((item) {
      int index = sondages.indexOf(item);
      return '${index + 1} - $item';
    }).toList();
    setState(() {});
  }

  _launchCamera() async {
    await availableCameras().then((value) async {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CameraPage(
            cameras: value,
          ),
        ),
      );
    });
    setState(() {});
  }
}
