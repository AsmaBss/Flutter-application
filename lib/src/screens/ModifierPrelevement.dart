import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/src/classes/images_temp.dart';
import 'package:flutter_application/src/classes/passes_temp.dart';
import 'package:flutter_application/src/models/MunitionReferenceEnum.dart';
import 'package:flutter_application/src/models/PasseModel.dart';
import 'package:flutter_application/src/models/PrelevementModel.dart';
import 'package:flutter_application/src/models/StatutEnum.dart';
import 'package:flutter_application/src/models/ImageModel.dart';
import 'package:flutter_application/src/repositories/PasseRepository.dart';
import 'package:flutter_application/src/repositories/PrelevementRepository.dart';
import 'package:flutter_application/src/repositories/ImageRepository.dart';
import 'package:flutter_application/src/screens/CameraPage.dart';
import 'package:flutter_application/src/screens/ModifierPasse.dart';
import 'package:flutter_application/src/screens/NouveauPasse.dart';
import 'package:flutter_application/src/widget/MyDialog.dart';
import 'package:flutter_application/src/widget/NouveauPrelevementFormWidget.dart';

class ModifierPrelevement extends StatefulWidget {
  final PrelevementModel prelevement;

  const ModifierPrelevement({required this.prelevement, Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ModifierPrelevementState();
  }
}

class _ModifierPrelevementState extends State<ModifierPrelevement> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController numero = TextEditingController();
  TextEditingController cotePlateforme = TextEditingController();
  TextEditingController coteASecuriser = TextEditingController();
  TextEditingController profondeurASecuriser = TextEditingController();
  TextEditingController remarques = TextEditingController();
  late MunitionReferenceEnum _selectedMunitionReference;
  StatutEnum? _selectedStatut;
  List<ImagesTemp> _images = [];
  List<PassesTemp> _passes = [];

  @override
  initState() {
    numero.text = widget.prelevement.numero.toString();
    _selectedMunitionReference = widget.prelevement.munitionReference;
    cotePlateforme.text = widget.prelevement.cotePlateforme.toString();
    profondeurASecuriser.text =
        widget.prelevement.profondeurASecuriser.toString();
    coteASecuriser.text = widget.prelevement.coteASecuriser.toString();
    remarques.text = widget.prelevement.remarques.toString();
    if (widget.prelevement.statut != null) {
      _selectedStatut = widget.prelevement.statut!;
    }
    _fetchImages();
    _fetchPasses();
    super.initState();
  }

  void refreshPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Modifier Prélèvement - ${widget.prelevement.numero}"),
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
                        mainAxisSpacing: 5,
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
                final int profSonde, profSec;
                int count = 0;
                final bool first;
                if (_passes.isEmpty) {
                  profSonde = 0;
                  profSec = 0;
                  count = 0;
                  first = true;
                } else {
                  for (var element in _passes) {
                    count += element.profondeurSecurisee;
                  }
                  profSonde = _passes.last.profondeurSonde;
                  profSec = _passes.last.profondeurSecurisee;
                  first = false;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NouveauPasse(
                      nvPasse: _addPasse,
                      munitionRef: _selectedMunitionReference,
                      cotePlateforme: cotePlateforme.text,
                      profSonde: profSonde,
                      profSec: profSec,
                      count: count,
                      first: first,
                    ),
                  ),
                );
                refreshPage();
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
                              setState(() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ModifierPasse(
                                          passe: item,
                                          index: index,
                                          updatePasse: _updatePasse)),
                                );
                              });
                            },
                          ),
                          onTap: () {
                            _deletePasse(context, index);
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
                        List<ImageModel> images = _images
                            .where((element) => element.id == 0)
                            .map((i) => ImageModel(image: i.image))
                            .toList();
                        List<PasseModel> passes = _passes
                            .where((element) => element.id == 0)
                            .map((i) => PasseModel(
                                munitionReference: i.munitionReference,
                                gradientMag: i.gradientMag,
                                profondeurSonde: i.profondeurSonde,
                                profondeurSecurisee: i.profondeurSecurisee,
                                coteSecurisee: i.coteSecurisee))
                            .toList();
                        PrelevementRepository().updatePrelevement(
                            context,
                            PrelevementModel(
                                id: widget.prelevement.id!,
                                numero: int.parse(numero.text),
                                munitionReference: _selectedMunitionReference,
                                cotePlateforme: int.parse(cotePlateforme.text),
                                coteASecuriser: int.parse(coteASecuriser.text),
                                profondeurASecuriser:
                                    int.parse(profondeurASecuriser.text),
                                statut: _selectedStatut,
                                remarques: remarques.text),
                            images,
                            passes,
                            widget.prelevement.id!);
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

  void _updatePasse(
      int index,
      MunitionReferenceEnum munitionReference,
      int gradientMag,
      int profondeurSonde,
      int coteSecurisee,
      int profondeurSecurisee) {
    for (var element in _passes) {
      if (_passes.indexOf(element) == index) {
        element.munitionReference = munitionReference;
        element.gradientMag = gradientMag;
        element.profondeurSonde = profondeurSonde;
        element.profondeurSecurisee = profondeurSecurisee;
        element.coteSecurisee = coteSecurisee;
      }
    }
    setState(() {});
  }

  _fetchImages() async {
    List<ImageModel> list = await ImageRepository()
        .getImagesByPrelevement(widget.prelevement.id!, context);
    for (var element in list) {
      _images.add(ImagesTemp(id: element.id!, image: element.image!));
    }
    setState(() {});
  }

  void _addImage(String image) {
    setState(() {
      _images.add(ImagesTemp(id: 0, image: image));
    });
  }

  void _deleteImage(int index) {
    ImagesTemp i = _images.elementAt(index);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MyDialog(
          onPressed: () async {
            if (i.id == 0) {
              _images.removeAt(index);
              Navigator.pop(context);
            } else {
              await ImageRepository().deleteImage(i.id, context);
              _images.removeAt(index);
            }
            refreshPage();
          },
        );
      },
    );
  }

  _fetchPasses() async {
    List<PasseModel> list = await PasseRepository()
        .getPassesByPrelevement(widget.prelevement.id!, context);
    for (var element in list) {
      _passes.add(PassesTemp(
          id: element.id!,
          munitionReference: element.munitionReference!,
          gradientMag: element.gradientMag!,
          profondeurSonde: element.profondeurSonde!,
          profondeurSecurisee: element.profondeurSecurisee!,
          coteSecurisee: element.coteSecurisee!));
    }
    setState(() {});
  }

  void _addPasse(MunitionReferenceEnum munitionReference, int gradientMag,
      int profondeurSonde, int coteSecurisee, int profondeurSecurisee) {
    setState(() {
      _passes.add(PassesTemp(
          id: 0,
          munitionReference: munitionReference,
          gradientMag: gradientMag,
          profondeurSonde: profondeurSonde,
          coteSecurisee: coteSecurisee,
          profondeurSecurisee: profondeurSecurisee));
    });
  }

  void _deletePasse(BuildContext context, int index) {
    PassesTemp i = _passes.elementAt(index);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MyDialog(
          onPressed: () async {
            if (i.id == 0) {
              _passes.removeAt(index);
              Navigator.pop(context);
            } else {
              PasseRepository().deletePasse(i.id, context);
              _passes.removeAt(index);
            }
            refreshPage();
          },
        );
      },
    );
  }
}
