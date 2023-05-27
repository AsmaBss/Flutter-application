import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application/src/sqlite/images-query.dart';
import 'package:flutter_application/src/models/position-model.dart';
import 'package:flutter_application/src/repositories/position-repository.dart';
import 'package:flutter_application/src/widget/my-grid_images.dart';
import 'package:latlong2/latlong.dart';

class FormMarker extends StatefulWidget {
  final LatLng point;
  final String adresse;
  const FormMarker({Key? key, required this.point, required this.adresse})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _FormMarkerState();
}

class _FormMarkerState extends State<FormMarker> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController address = TextEditingController();
  TextEditingController latlong = TextEditingController();
  TextEditingController description = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    address.dispose();
    latlong.dispose();
    description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Form"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /*MyForm(
              formKey: _formKey,
              address: widget.adresse,
              latlong: "${widget.point.latitude} - ${widget.point.longitude}",
              description: description,
              textButton: TextButton.icon(
                onPressed: () => _launchCamera(widget.point),
                icon: Icon(Icons.camera_alt),
                label: Text("Take picture"),
              ),
            ),
            */
            FutureBuilder(
              future: ImagesQuery().showImages(),
              //PositionDetailsQuery().showPositionDetailsByPositionId(int.parse(widget.element.id.toString())),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Center(child: Text("There is no data"));
                }
                return MyGridImages(
                  itemCount: snapshot.data?.length,
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
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // Submit form
                  var list = await ImagesQuery().showImages();
                  // ignore: use_build_context_synchronously
                  PositionRepository().addPosition(
                      PositionModel(
                          address: widget.adresse,
                          latitude: widget.point.latitude.toString(),
                          longitude: widget.point.longitude.toString(),
                          description: description.text),
                      list,
                      context);
                  for (var i in list) {
                    ImagesQuery().deleteImage(i[0]);
                  }
                }
              },
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
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
