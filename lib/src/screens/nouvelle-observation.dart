import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/src/classes/images_temp.dart';
import 'package:flutter_application/src/models/ParcelleModel.dart';
import 'package:flutter_application/src/models/images-observation-model.dart';
import 'package:flutter_application/src/models/observation-model.dart';
import 'package:flutter_application/src/screens/camera-page.dart';
import 'package:flutter_application/src/sqlite/observation-query.dart';
import 'package:flutter_application/src/widget/my-dialog.dart';
import 'package:flutter_application/src/widget/nouvelle-observation-form-widget.dart';
import 'package:latlong2/latlong.dart';

class NouvelleObservation extends StatefulWidget {
  final LatLng latLng;
  final ParcelleModel parcelle;

  const NouvelleObservation(
      {required this.latLng, required this.parcelle, Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _NouvelleObservationState();
}

class _NouvelleObservationState extends State<NouvelleObservation> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nom = TextEditingController();
  TextEditingController description = TextEditingController();
  List<ImagesTemp> _images = [];

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
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
        title: Text("Nouvelle Observation \n${widget.parcelle.nom}"),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(30.0),
        child: Column(
          children: [
            NouvelleObservationFormWidget(
              formKey: _formKey,
              nom: nom,
              description: description,
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
                        List<ImagesObservationModel> images = _images
                            .map((i) => ImagesObservationModel(image: i.image))
                            .toList();
                        /*ObservationRepository().addObservation(
                            context,
                            ObservationModel(
                              nom: nom.text,
                              description: description.text,
                              latitude: widget.latLng.latitude.toString(),
                              longitude: widget.latLng.longitude.toString(),
                            ),
                            widget.parcelle,
                            images);*/
                        ObservationQuery().addObservation(
                            ObservationModel(
                                nom: nom.text,
                                description: description.text,
                                latitude: widget.latLng.latitude.toString(),
                                longitude: widget.latLng.longitude.toString(),
                                parcelle: widget.parcelle.id),
                            images,
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
}
