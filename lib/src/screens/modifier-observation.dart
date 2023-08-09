import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/src/classes/images_temp.dart';
import 'package:flutter_application/src/models/images-observation-model.dart';
import 'package:flutter_application/src/models/observation-model.dart';
import 'package:flutter_application/src/screens/camera-page.dart';
import 'package:flutter_application/src/sqlite/images-observation.dart';
import 'package:flutter_application/src/sqlite/observation-query.dart';
import 'package:flutter_application/src/widget/my-dialog.dart';
import 'package:flutter_application/src/widget/nouvelle-observation-form-widget.dart';

class ModifierObservation extends StatefulWidget {
  final ObservationModel observation;

  const ModifierObservation({required this.observation, Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ModifierObservationState();
}

class _ModifierObservationState extends State<ModifierObservation> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nom = TextEditingController();
  TextEditingController description = TextEditingController();
  List<ImagesTemp> _images = [];

  @override
  initState() {
    super.initState();
    nom.text = widget.observation.nom.toString();
    description.text = widget.observation.description.toString();
    _fetchImages();
  }

  void refreshPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Modifier Observation \n${widget.observation.nom}"),
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
                        List<ImagesObservationModel> images = [];
                        for (var element in _images) {
                          if (element.id == 0) {
                            images.add(ImagesObservationModel(
                                image: element.image,
                                observation: widget.observation.id));
                          } else if (element.id != 0) {
                            images.add(ImagesObservationModel(
                                id: element.id,
                                image: element.image,
                                observation: widget.observation.id));
                          }
                        }
                        /*ObservationRepository().updateObservation(
                            context,
                            ObservationModel(
                              id: widget.observation.id,
                              nom: nom.text,
                              description: description.text,
                              latitude: widget.observation.latitude,
                              longitude: widget.observation.longitude,
                            ),
                            images);*/
                        ObservationQuery().updateObservation(
                            ObservationModel(
                              id: widget.observation.id,
                              nom: nom.text,
                              description: description.text,
                              latitude: widget.observation.latitude,
                              longitude: widget.observation.longitude,
                              parcelle: widget.observation.parcelle,
                            ),
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

  _fetchImages() async {
    /*await ImagesObservationRepository()
        .getImagesByObservation(widget.observation.id!, context)
        .then((value) {
      for (var element in value!) {
        _images.add(ImagesTemp(id: element.id!, image: element.image!));
      }
    });*/
    await ImagesObservationQuery()
        .showImagesObservationByObservationId(widget.observation.id!)
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
              /*await ImagesObservationRepository()
                  .deleteImageObservation(i.id, context);*/
              await ImagesObservationQuery().deleteImageObservation(
                  ImagesObservationModel(
                      id: i.id,
                      image: i.image,
                      observation: widget.observation.id),
                  context);
              _images.removeAt(index);
            }
            /*_images.removeAt(index);
            Navigator.pop(context);*/
            refreshPage();
          },
        );
      },
    );
  }
}
