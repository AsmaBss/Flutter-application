import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/src/classes/images_temp.dart';
import 'package:flutter_application/src/classes/passes_temp.dart';
import 'package:flutter_application/src/models/MunitionReferenceEnum.dart';
import 'package:flutter_application/src/models/PasseModel.dart';
import 'package:flutter_application/src/models/PlanSondageModel.dart';
import 'package:flutter_application/src/models/PrelevementModel.dart';
import 'package:flutter_application/src/models/SecurisationModel.dart';
import 'package:flutter_application/src/models/StatutEnum.dart';
import 'package:flutter_application/src/models/ImageModel.dart';
import 'package:flutter_application/src/screens/camera-page.dart';
import 'package:flutter_application/src/screens/modifier-passe.dart';
import 'package:flutter_application/src/screens/nouveau-passe.dart';
import 'package:flutter_application/src/sqlite/prelevement-query.dart';
import 'package:flutter_application/src/widget/my-dialog.dart';
import 'package:flutter_application/src/widget/nouveau-prelevement-form-widget.dart';
import 'package:photo_view/photo_view.dart';

class NouveauPrelevement extends StatefulWidget {
  final PlanSondageModel planSondage;
  final SecurisationModel? securisation;

  const NouveauPrelevement(
      {required this.planSondage, required this.securisation, Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _NouveauPrelevementState();
}

class _NouveauPrelevementState extends State<NouveauPrelevement> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController numero = TextEditingController();
  TextEditingController cotePlateforme = TextEditingController(text: "0.0");
  TextEditingController coteASecuriser = TextEditingController(text: "0.0");
  TextEditingController profondeurASecuriser =
      TextEditingController(text: "0.0");
  TextEditingController remarques = TextEditingController();
  MunitionReferenceEnum? _selectedMunitionReference;
  PlanSondageModel? _selectedSondage;
  StatutEnum? _selectedStatut;
  List<ImagesTemp> _images = [];
  List<PassesTemp> _passes = [];
  late TransformationController transformController;
  TapDownDetails? tapDownDetails;

  @override
  initState() {
    _selectedSondage = widget.planSondage;
    numero.text = _selectedSondage!.baseRef.toString();
    if (widget.securisation != null) {
      _selectedMunitionReference = widget.securisation!.munitionReference!;
      cotePlateforme.text = widget.securisation!.cotePlateforme.toString();
      coteASecuriser.text = widget.securisation!.coteASecuriser.toString();
      profondeurASecuriser.text =
          widget.securisation!.profondeurASecuriser.toString();
    }
    transformController = TransformationController();
    super.initState();
  }

  @override
  void dispose() {
    numero.dispose();
    cotePlateforme.dispose();
    coteASecuriser.dispose();
    profondeurASecuriser.dispose();
    remarques.dispose();
    transformController.dispose();
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
                      munitionRef: _selectedMunitionReference!,
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
                            _deletePasse(index);
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
                        List<ImageModel> images = _images
                            .map((i) => ImageModel(image: i.image))
                            .toList();
                        List<PasseModel> passes = _passes
                            .map((i) => PasseModel(
                                munitionReference: i.munitionReference,
                                gradientMag: i.gradientMag,
                                profondeurSonde: i.profondeurSonde,
                                profondeurSecurisee: i.profondeurSecurisee,
                                coteSecurisee: i.coteSecurisee))
                            .toList();
                        /*PrelevementRepository().addPrelevement(
                            context,
                            PrelevementModel(
                                numero: numero.text,
                                munitionReference: _selectedMunitionReference!,
                                cotePlateforme:
                                    double.parse(cotePlateforme.text),
                                coteASecuriser:
                                    double.parse(coteASecuriser.text),
                                profondeurASecuriser:
                                    double.parse(profondeurASecuriser.text),
                                statut: _selectedStatut,
                                remarques: remarques.text,
                                plan_sondage: widget.planSondage.id),
                            passes,
                            images);*/
                        PrelevementQuery().addPrelevement(
                            PrelevementModel(
                                numero: numero.text,
                                munitionReference: _selectedMunitionReference!,
                                cotePlateforme:
                                    double.parse(cotePlateforme.text),
                                coteASecuriser:
                                    double.parse(coteASecuriser.text),
                                profondeurASecuriser:
                                    double.parse(profondeurASecuriser.text),
                                statut: _selectedStatut,
                                remarques: remarques.text,
                                plan_sondage: widget.planSondage.id),
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
    String cotePlat = cotePlateforme.text;
    String profASec = profondeurASecuriser.text;
    if (cotePlat.isEmpty || profASec.isEmpty) {
      coteASecuriser.text = '';
      return;
    }
    double result = double.parse(cotePlat) - double.parse(profASec);
    coteASecuriser.text = result.toString();
    setState(() {});
  }

  void _addImage(String image) {
    setState(() {
      _images.add(ImagesTemp(id: 0, image: image));
    });
  }

  void _deleteImage(int index) {
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

  void _deletePasse(int index) {
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
}
