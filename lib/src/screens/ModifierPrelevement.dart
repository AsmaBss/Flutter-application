import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/PasseModel.dart';
import 'package:flutter_application/src/models/PrelevementModel.dart';
import 'package:flutter_application/src/models/images-model.dart';
import 'package:flutter_application/src/repositories/PasseRepository.dart';
import 'package:flutter_application/src/repositories/images-repository.dart';
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
  TextEditingController munitionRef = TextEditingController();
  TextEditingController cotePlateforme = TextEditingController();
  TextEditingController coteASecurise = TextEditingController();
  TextEditingController profondeurASecurise = TextEditingController();
  TextEditingController remarques = TextEditingController();
  String? statut;

  @override
  initState() {
    numero.text = widget.prelevement.numero.toString();
    munitionRef.text = widget.prelevement.munitionReference.toString();
    cotePlateforme.text = widget.prelevement.cotePlateforme.toString();
    coteASecurise.text = widget.prelevement.coteASecuriser.toString();
    profondeurASecurise.text =
        widget.prelevement.profondeurASecuriser.toString();
    remarques.text = widget.prelevement.remarques.toString();
    statut = widget.prelevement.statut.toString();
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(30.0),
        child: Column(
          children: [
            NouveauPrelevementFormWidget(
              formKey: _formKey,
              numero: numero,
              //munitionRef: munitionRef,
              cotePlateforme: cotePlateforme,
              profondeurASecurise: profondeurASecurise,
              coteASecurise: coteASecurise,
              imageGrid: FutureBuilder(
                future: ImagesRepository()
                    .getByPrelevement(widget.prelevement.id!, context),
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
                      padding: EdgeInsets.all(10.0),
                      addAutomaticKeepAlives: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 0,
                        crossAxisSpacing: 5,
                        childAspectRatio: 1,
                        mainAxisExtent: 170,
                      ),
                      shrinkWrap: true,
                      itemCount: snapshot.data?.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = snapshot.data![index];
                        return GestureDetector(
                          child: Image.memory(
                              Base64Decoder().convert(item.image!)),
                          onTap: () {
                            _deleteImage(context, item.id!);
                          },
                        );
                      },
                    );
                  }
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
              statut: statut,
              onChangedStatut: (value) => {
                setState(() {
                  statut = value.toString();
                })
              },
              nvPasse: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NouveauPasse(nvPasse: _addPasse),
                  ),
                )
              },
              listPasse: FutureBuilder(
                future: PasseRepository()
                    .getByPrelevement(widget.prelevement.id!, context),
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
                        var ps = item.profondeurSonde! - 50;
                        return ListTile(
                          title: Text('$ps - ${item.profondeurSonde}',
                              style: TextStyle(fontSize: 17)),
                          trailing: Text(
                            'Gradient Mag : ${item.gradientMag}',
                            style: TextStyle(fontSize: 15),
                          ),
                          onTap: () {
                            _updatePasse(context, item);
                          },
                          onLongPress: () {
                            _deletePasse(context, item.id!);
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
                      if (_formKey.currentState!.validate()) {}
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

  void _addPasse(String munitionReference, int profondeurSonde, int gradientMag,
      int profondeurSecurisee, int coteSecurisee) {
    setState(() {
      PasseRepository().addPasse(
          PasseModel(
              munitionReference: munitionReference,
              profondeurSonde: profondeurSonde,
              gradientMag: gradientMag,
              profondeurSecurisee: profondeurSecurisee,
              coteSecurisee: coteSecurisee),
          widget.prelevement.id!,
          context);
    });
  }

  void _updatePasse(BuildContext context, PasseModel item) {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ModifierPasse(passe: item),
        ),
      );
    });
  }

  void _deletePasse(BuildContext context, int idPass) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return MyDialog(
          onPressed: () async {
            await PasseRepository().deletePasse(idPass, context);
            refreshPage();
          },
        );
      },
    );
  }

  void _addImage(String image) async {
    await ImagesRepository()
        .addImage(ImagesModel(image: image), widget.prelevement.id!, context);
    refreshPage();
  }

  void _deleteImage(BuildContext context, int idImg) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return MyDialog(
          onPressed: () async {
            await ImagesRepository().deleteImage(idImg, context);
            refreshPage();
          },
        );
      },
    );
  }
}
