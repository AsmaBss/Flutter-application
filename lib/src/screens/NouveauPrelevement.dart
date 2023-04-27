import 'dart:async';
import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/src/database/passe-query.dart';
import 'package:flutter_application/src/models/PlanSondageModel.dart';
import 'package:flutter_application/src/models/PrelevementModel.dart';
import 'package:flutter_application/src/models/SecurisationModel.dart';
import 'package:flutter_application/src/repositories/PrelevementRepository.dart';
import 'package:flutter_application/src/screens/CameraPage.dart';
import 'package:flutter_application/src/screens/NouveauPasse.dart';
import 'package:flutter_application/src/screens/maps.dart';
import 'package:flutter_application/src/widget/NouveauPrelevementFormWidget.dart';

import '../database/images-query.dart';

class NouveauPrelevement extends StatefulWidget {
  final List<PlanSondageModel?> planSondage;
  //final int id;
  final SecurisationModel securisation;
  const NouveauPrelevement(
      {required this.planSondage, required this.securisation, Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _NouveauPrelevementState();
}

class _NouveauPrelevementState extends State<NouveauPrelevement> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController numero = TextEditingController();
  TextEditingController munitionRef = TextEditingController();
  TextEditingController cotePlateforme = TextEditingController();
  TextEditingController coteASecurise = TextEditingController();
  TextEditingController profondeurASecurise = TextEditingController();
  TextEditingController remarques = TextEditingController();
  List<String> _coordinates = [];
  PlanSondageModel? _selectedSondage;
  String? statut;
  bool _isShown = true;

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    numero.dispose();
    munitionRef.dispose();
    cotePlateforme.dispose();
    coteASecurise.dispose();
    profondeurASecurise.dispose();
    remarques.dispose();
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
              numero: numero,
              munitionRef: munitionRef,
              valuePlanSondage: _selectedSondage,
              itemsPlanSondage: widget.planSondage.map((value) {
                return DropdownMenuItem<PlanSondageModel>(
                  value: value,
                  child: Text(value!.geometry.toString()),
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
              imageGrid: FutureBuilder(
                future: ImagesQuery().showImages(),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return Center(child: Text("There is no data"));
                  }
                  return GridView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.all(0.0),
                    addAutomaticKeepAlives: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 0,
                      crossAxisSpacing: 5,
                      childAspectRatio: 1,
                      mainAxisExtent: 170,
                    ),
                    shrinkWrap: true,
                    itemCount: snapshot.data?.length, //5,
                    itemBuilder: (BuildContext context, int index) {
                      final item = snapshot.data![index];
                      return GestureDetector(
                        child: Image.memory(Base64Decoder().convert(item[1])),
                        //Image.file(File(item[1])),
                        onTap: () {
                          _deleteImage(context, item[0]);
                        },
                      );
                    },
                  );
                },
              ),
              onPressedCam: () => _launchCamera(),
              remarques: remarques,
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
                    onPressed: () async {
                      print(statut.toString());
                      print(remarques.text);
                      if (_formKey.currentState!.validate()) {
                        List images = await ImagesQuery().showImages();
                        List passes = await PasseQuery().showPasses();

                        PrelevementRepository().addPrelevement(
                            context,
                            PrelevementModel(
                                numero: int.parse(numero.text),
                                munitionReference: munitionRef.text,
                                cotePlateforme: int.parse(cotePlateforme.text),
                                coteASecuriser: int.parse(coteASecurise.text),
                                profondeurASecuriser:
                                    int.parse(profondeurASecurise.text),
                                statut: statut.toString(),
                                remarques: remarques.text),
                            passes,
                            images,
                            widget.securisation,
                            _selectedSondage!);
                        for (var i in images) {
                          ImagesQuery().deleteImage(i[0]);
                        }
                        for (var i in images) {
                          PasseQuery().deletePasse(i[0]);
                        }
                        /*Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => Maps()));*/
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

  void _deleteImage(BuildContext context, int idImg) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Please Confirm'),
          content: const Text('Are you sure to remove this image?'),
          actions: [
            TextButton(
                onPressed: () {
                  setState(() {
                    _isShown = false;
                    ImagesQuery().deleteImage(idImg);
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Yes')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('No'))
          ],
        );
      },
    );
  }
}
