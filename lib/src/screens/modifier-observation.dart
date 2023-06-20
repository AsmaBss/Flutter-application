import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/src/classes/images_temp.dart';
import 'package:flutter_application/src/models/ParcelleModel.dart';
import 'package:flutter_application/src/models/images-observation-model.dart';
import 'package:flutter_application/src/models/observation-model.dart';
import 'package:flutter_application/src/repositories/images-observation-repository.dart';
import 'package:flutter_application/src/repositories/observation-repository.dart';
import 'package:flutter_application/src/screens/camera-page.dart';
import 'package:flutter_application/src/widget/my-dialog.dart';
import 'package:flutter_application/src/widget/nouvelle-observation-form-widget.dart';
import 'package:latlong2/latlong.dart';

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
    print("tettt");
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
        title: Text("Modifier Observation"),
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
                        ObservationRepository().updateObservation(
                            context,
                            ObservationModel(
                              id: widget.observation.id,
                              nom: nom.text,
                              description: description.text,
                              latitude: widget.observation.latitude,
                              longitude: widget.observation.longitude,
                            ),
                            images);
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
    List<ImagesObservationModel> list = await ImagesObservationRepository()
        .getImagesByObservation(widget.observation.id!, context)
        .catchError((error) {});
    print(list);
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
