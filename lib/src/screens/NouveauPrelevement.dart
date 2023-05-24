import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/MunitionReferenceEnum.dart';
import 'package:flutter_application/src/models/PasseModel.dart';
import 'package:flutter_application/src/models/PlanSondageModel.dart';
import 'package:flutter_application/src/models/PrelevementModel.dart';
import 'package:flutter_application/src/models/SecurisationModel.dart';
import 'package:flutter_application/src/models/StatutEnum.dart';
import 'package:flutter_application/src/models/images-model.dart';
import 'package:flutter_application/src/repositories/PrelevementRepository.dart';
import 'package:flutter_application/src/screens/CameraPage.dart';
import 'package:flutter_application/src/screens/NouveauPasse.dart';
import 'package:flutter_application/src/widget/MyDialog.dart';
import 'package:flutter_application/src/widget/NouveauPrelevementFormWidget.dart';

class NouveauPrelevement extends StatefulWidget {
  final PlanSondageModel planSondage;
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
  TextEditingController cotePlateforme = TextEditingController();
  TextEditingController coteASecuriser = TextEditingController();
  TextEditingController profondeurASecuriser = TextEditingController();
  TextEditingController remarques = TextEditingController();
  MunitionReferenceEnum? _selectedMunitionReference;
  PlanSondageModel? _selectedSondage;
  StatutEnum? _selectedStatut;
  List<ImagesTemp> _images = [];
  List<PassesTemp> _passes = [];

  @override
  initState() {
    _selectedSondage = widget.planSondage;
    _selectedMunitionReference = widget.securisation.munitionReference;
    cotePlateforme.text = widget.securisation.cotePlateforme.toString();
    coteASecuriser.text = widget.securisation.coteASecuriser.toString();
    profondeurASecuriser.text =
        widget.securisation.profondeurASecuriser.toString();
    super.initState();
  }

  @override
  void dispose() {
    numero.dispose();
    cotePlateforme.dispose();
    coteASecuriser.dispose();
    profondeurASecuriser.dispose();
    remarques.dispose();
    super.dispose();
  }

  void refreshPage() {
    setState(() {});
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
              onChangedCotePlateforme: (value) => updateCoteASecuriserValue(),
              profondeurASecuriser: profondeurASecuriser,
              onChangedProfondeurASecuriser: (value) =>
                  updateCoteASecuriserValue(),
              coteASecuriser: coteASecuriser,
              imageGrid: (_images.isEmpty)
                  ? Center(child: Text("Il n'y a pas encore des images"))
                  : GridView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.all(5.0),
                      addAutomaticKeepAlives: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 0,
                        crossAxisSpacing: 5,
                        childAspectRatio: 1,
                        mainAxisExtent: 170,
                      ),
                      shrinkWrap: true,
                      itemCount: _images.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          child: Image.memory(
                              Base64Decoder().convert(_images[index].image)),
                          onTap: () => _deleteImage(index),
                        );
                      },
                    ),
              onPressedCam: () async {
                await availableCameras().then((value) async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CameraPage(onPictureTaken: _addImage, cameras: value),
                    ),
                  );
                });
              },
              remarques: remarques,
              selectedStatut: _selectedStatut,
              onChangedStatut: (value) {
                setState(() {
                  _selectedStatut = value;
                });
              },
              nvPasse: () {
                final profSonde;
                if (_passes.isEmpty) {
                  profSonde = 0;
                } else {
                  profSonde = _passes.last.profondeurSonde;
                }
                print("profSonde => $profSonde");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NouveauPasse(
                      nvPasse: _addPasse,
                      securisation: widget.securisation,
                      cotePlateforme: cotePlateforme.text,
                      profSonde: profSonde,
                    ),
                  ),
                );
              },
              listPasse: (_passes.isEmpty)
                  ? Center(child: Text("Il n'y a pas encore des passes"))
                  : ListView.builder(
                      padding: EdgeInsets.all(8),
                      itemCount: _passes.length,
                      itemBuilder: (context, index) {
                        final item = _passes[index];
                        return ListTile(
                          title: Text('${item.profondeurSonde}',
                              style: TextStyle(fontSize: 17)),
                          trailing: Text(
                            'Gradient Mag : ${item.gradientMag}',
                            style: TextStyle(fontSize: 15),
                          ),
                          leading: IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              //_updatePasse(item, context);
                            },
                          ),
                          onTap: () {
                            _deletePasse(index);
                          },
                        );
                      },
                    ),
            ),
            Image.asset("assets/Profondeur-vs-intensité - ESID.JPG"),
            Padding(
              padding: EdgeInsets.all(40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        List<ImagesModel> images = _images
                            .map((i) => ImagesModel(image: i.image))
                            .toList();
                        List<PasseModel> passes = _passes
                            .map((i) => PasseModel(
                                munitionReference: i.munitionReference,
                                gradientMag: i.gradientMag,
                                profondeurSonde: i.profondeurSonde,
                                profondeurSecurisee: i.profondeurSecurisee,
                                coteSecurisee: i.coteSecurisee))
                            .toList();
                        for (var element in passes) {
                          print('prof => ${element.profondeurSonde}');
                        }
                        PrelevementRepository().addPrelevement(
                            context,
                            PrelevementModel(
                                numero: int.parse(numero.text),
                                munitionReference: _selectedMunitionReference,
                                cotePlateforme: int.parse(cotePlateforme.text),
                                coteASecuriser: int.parse(coteASecuriser.text),
                                profondeurASecuriser:
                                    int.parse(profondeurASecuriser.text),
                                statut: _selectedStatut,
                                remarques: remarques.text),
                            passes,
                            images,
                            widget.securisation,
                            _selectedSondage!);
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
    int result = int.parse(firstValue) - int.parse(secondValue);
    coteASecuriser.text = result.toString();
    setState(() {});
  }

  void _addImage(String image) {
    setState(() {
      _images.add(ImagesTemp(image: image));
    });
  }

  void _deleteImage(int index) {
    ImagesTemp i = _images.elementAt(index);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MyDialog(
          onPressed: () async {
            _images.removeAt(index);
            Navigator.pop(context);
            refreshPage();
          },
        );
      },
    );
  }

  void _addPasse(MunitionReferenceEnum munitionReference, int gradientMag,
      int profondeurSonde, int profondeurSecurisee, int coteSecurisee) {
    setState(() {
      _passes.add(PassesTemp(
          munitionReference: munitionReference,
          gradientMag: gradientMag,
          profondeurSonde: profondeurSonde,
          coteSecurisee: coteSecurisee,
          profondeurSecurisee: profondeurSecurisee));
    });
    for (var element in _passes) {
      print("profondeurSonde => ${element.profondeurSonde}");
    }
  }

  void _deletePasse(int index) {
    PassesTemp i = _passes.elementAt(index);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MyDialog(
          onPressed: () async {
            _passes.removeAt(index);
            Navigator.pop(context);
            refreshPage();
          },
        );
      },
    );
  }

  List<ImagesModel> _allImages() {
    return _images.map((i) => ImagesModel(image: i.image)).toList();
  }

  List<PasseModel> _allPasses() {
    return _passes
        .map((i) => PasseModel(
            munitionReference: i.munitionReference,
            profondeurSonde: i.profondeurSonde,
            gradientMag: i.gradientMag,
            profondeurSecurisee: i.profondeurSecurisee,
            coteSecurisee: i.coteSecurisee,
            prelevement: null))
        .toList();
  }
}

class ImagesTemp {
  String image;

  ImagesTemp({required this.image});
}

class PassesTemp {
  MunitionReferenceEnum munitionReference;
  int profondeurSonde, gradientMag, profondeurSecurisee, coteSecurisee;

  PassesTemp(
      {required this.munitionReference,
      required this.gradientMag,
      required this.profondeurSonde,
      required this.coteSecurisee,
      required this.profondeurSecurisee});
}
