import 'dart:async';
import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/src/database/passe-query.dart';
import 'package:flutter_application/src/models/PlanSondageModel.dart';
import 'package:flutter_application/src/models/PrelevementModel.dart';
import 'package:flutter_application/src/models/SecurisationModel.dart';
import 'package:flutter_application/src/repositories/PrelevementRepository.dart';
import 'package:flutter_application/src/repositories/plan-sondage-repository.dart';
import 'package:flutter_application/src/screens/CameraPage.dart';
import 'package:flutter_application/src/screens/NouveauPasse.dart';
import 'package:flutter_application/src/widget/MyDialog.dart';
import 'package:flutter_application/src/widget/NouveauPrelevementFormWidget.dart';
import 'package:latlong2/latlong.dart';

import '../database/images-query.dart';

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
  TextEditingController munitionRef = TextEditingController();
  TextEditingController cotePlateforme = TextEditingController();
  TextEditingController coteASecurise = TextEditingController();
  TextEditingController profondeurASecurise = TextEditingController();
  TextEditingController remarques = TextEditingController();
  List<String> _coordinates = [];
  PlanSondageModel? _selectedSondage;
  String? statut;
  bool _isShownImage = true;
  bool _isShownPasse = true;

  @override
  initState() {
    _selectedSondage = widget.planSondage;
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
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
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
              munitionRef: munitionRef,
              cotePlateforme: cotePlateforme,
              profondeurASecurise: profondeurASecurise,
              coteASecurise: coteASecurise,
              imageGrid: FutureBuilder(
                future: ImagesQuery().showImages(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return Center(
                        child: Text("Il n'y a pas encore des images"));
                  } else {
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
                  }
                },
              ),
              onPressedCam: () => _launchCamera(),
              remarques: remarques,
              statut: statut,
              onChangedStatut: (value) => {
                setState(() {
                  statut = value.toString();
                })
              },
              nvPasse: () => _addPasse(context),
              listPasse: FutureBuilder(
                future: PasseQuery().showPasses(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return Center(
                        child: Text("Il n'y a pas encore des passes"));
                  } else {
                    return ListView.builder(
                      padding: EdgeInsets.all(8),
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        final item = snapshot.data![index];
                        var ps = item[2] - 50;
                        return ListTile(
                          title: Text('$ps - ${item[2]}',
                              style: TextStyle(fontSize: 17)),
                          trailing: Text(
                            'Gradient Mag : ${item[3]}',
                            style: TextStyle(fontSize: 15),
                          ),
                          onTap: () {
                            _deletePasse(context, item[0]);
                          },
                        );
                      },
                    );
                  }
                },
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

  /*_getPlanSondage(LatLng point) async {
    String coord = "(${widget.point.longitude}, ${widget.point.latitude})";
    _selectedSondage =
        await PlanSondageRepository().getByCoords(coord, context);
  }*/

  void _addPasse(BuildContext context) async {
    final result = await Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => NouveauPasse()));
    setState(() {});
  }

  void _deletePasse(BuildContext context, int idPass) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return MyDialog(
          onPressed: () {
            setState(() {
              _isShownPasse = false;
              PasseQuery().deletePasse(idPass);
            });
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _deleteImage(BuildContext context, int idImg) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return MyDialog(
          onPressed: () {
            setState(() {
              _isShownImage = false;
              ImagesQuery().deleteImage(idImg);
            });
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
