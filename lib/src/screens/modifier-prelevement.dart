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
import 'package:flutter_application/src/screens/camera-page.dart';
import 'package:flutter_application/src/screens/modifier-passe.dart';
import 'package:flutter_application/src/screens/nouveau-passe.dart';
import 'package:flutter_application/src/sqlite/images-query.dart';
import 'package:flutter_application/src/sqlite/passe-query.dart';
import 'package:flutter_application/src/sqlite/prelevement-query.dart';
import 'package:flutter_application/src/widget/my-dialog.dart';
import 'package:flutter_application/src/widget/nouveau-prelevement-form-widget.dart';
import 'package:photo_view/photo_view.dart';

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
              onChangedDropdownMunitionRef: (newValue) {
                setState(() {
                  _selectedMunitionReference = newValue!;
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
                final double profSonde, profSec;
                double count = 0;
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
                      cotePlateforme: double.parse(cotePlateforme.text),
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
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 260.0,
              child: PhotoView(
                backgroundDecoration: BoxDecoration(color: Colors.white),
                imageProvider:
                    AssetImage("assets/Profondeur-vs-intensité - ESID.JPG"),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        List<ImageModel> images = [];
                        for (var element in _images) {
                          if (element.id == 0) {
                            images.add(ImageModel(
                                image: element.image,
                                prelevement: widget.prelevement.id));
                          } else if (element.id != 0) {
                            images.add(ImageModel(
                                id: element.id,
                                image: element.image,
                                prelevement: widget.prelevement.id));
                          }
                        }
                        List<PasseModel> passes = [];
                        for (var element in _passes) {
                          if (element.id == 0) {
                            passes.add(PasseModel(
                                munitionReference: element.munitionReference,
                                gradientMag: element.gradientMag,
                                profondeurSonde: element.profondeurSonde,
                                profondeurSecurisee:
                                    element.profondeurSecurisee,
                                coteSecurisee: element.coteSecurisee,
                                prelevement: widget.prelevement.id));
                          } else if (element.id != 0) {
                            passes.add(PasseModel(
                                id: element.id,
                                munitionReference: element.munitionReference,
                                gradientMag: element.gradientMag,
                                profondeurSonde: element.profondeurSonde,
                                profondeurSecurisee:
                                    element.profondeurSecurisee,
                                coteSecurisee: element.coteSecurisee,
                                prelevement: widget.prelevement.id));
                          }
                        }
                        /*PrelevementRepository().updatePrelevement(
                            context,
                            PrelevementModel(
                                id: widget.prelevement.id!,
                                numero: numero.text,
                                munitionReference: _selectedMunitionReference,
                                cotePlateforme:
                                    double.parse(cotePlateforme.text),
                                coteASecuriser:
                                    double.parse(coteASecuriser.text),
                                profondeurASecuriser:
                                    double.parse(profondeurASecuriser.text),
                                statut: _selectedStatut,
                                remarques: remarques.text,
                                plan_sondage: widget.prelevement.plan_sondage),
                            images,
                            passes,
                            widget.prelevement.id!);*/
                        PrelevementQuery().updatePrelevement(
                            PrelevementModel(
                                id: widget.prelevement.id!,
                                numero: numero.text,
                                munitionReference: _selectedMunitionReference,
                                cotePlateforme:
                                    double.parse(cotePlateforme.text),
                                coteASecuriser:
                                    double.parse(coteASecuriser.text),
                                profondeurASecuriser:
                                    double.parse(profondeurASecuriser.text),
                                statut: _selectedStatut,
                                remarques: remarques.text,
                                plan_sondage: widget.prelevement.plan_sondage),
                            images,
                            passes,
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

  _fetchImages() async {
    /*await ImagesPrelevementRepository()
        .getImagesByPrelevement(widget.prelevement.id!, context)
        .then((value) {
      for (var element in value!) {
        _images.add(ImagesTemp(id: element.id!, image: element.image!));
      }
    });*/
    ImagesQuery()
        .showImagesPrelevementByPrelevementId(widget.prelevement.id!)
        .then((value) {
      for (var element in value!) {
        _images.add(ImagesTemp(id: element.id!, image: element.image!));
      }
    });
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
              //await ImagesPrelevementRepository().deleteImage(i.id, context);
              await ImagesQuery().deleteImagePrelevement(
                  ImageModel(
                      id: i.id,
                      image: i.image,
                      prelevement: widget.prelevement.id),
                  context);
              _images.removeAt(index);
            }
            refreshPage();
          },
        );
      },
    );
  }

  _fetchPasses() async {
    /*await PasseRepository()
        .getByPrelevement(widget.prelevement.id!, context)
        .then((value) {
      for (var element in value!) {
        _passes.add(PassesTemp(
            id: element.id!,
            munitionReference: element.munitionReference!,
            gradientMag: element.gradientMag!,
            profondeurSonde: element.profondeurSonde!,
            profondeurSecurisee: element.profondeurSecurisee!,
            coteSecurisee: element.coteSecurisee!));
      }
    });*/
    await PasseQuery()
        .showPasseByPrelevementId(widget.prelevement.id!)
        .then((value) {
      for (var element in value!) {
        _passes.add(PassesTemp(
            id: element.id!,
            munitionReference: element.munitionReference!,
            gradientMag: element.gradientMag!,
            profondeurSonde: element.profondeurSonde!,
            profondeurSecurisee: element.profondeurSecurisee!,
            coteSecurisee: element.coteSecurisee!));
      }
    });
    setState(() {});
  }

  void _addPasse(
      MunitionReferenceEnum munitionReference,
      double gradientMag,
      double profondeurSonde,
      double coteSecurisee,
      double profondeurSecurisee) {
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
              /*PasseRepository().deletePasse(i.id, context);*/
              PasseQuery().deletePasse(
                  PasseModel(
                      id: i.id,
                      gradientMag: i.gradientMag,
                      profondeurSonde: i.profondeurSonde,
                      munitionReference: i.munitionReference,
                      coteSecurisee: i.coteSecurisee,
                      profondeurSecurisee: i.profondeurSecurisee,
                      prelevement: widget.prelevement.id),
                  context);
              _passes.removeAt(index);
            }
            refreshPage();
          },
        );
      },
    );
  }

  void _updatePasse(
      int index,
      MunitionReferenceEnum munitionReference,
      double gradientMag,
      double profondeurSonde,
      double coteSecurisee,
      double profondeurSecurisee) {
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
}
