/*import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/src/screens/cam.dart';
import 'package:image_picker/image_picker.dart';

class FormImages {
  String title;
  List<Imagee> images;

  FormImages({required this.title, required this.images});
}

class Imagee {
  String path;

  Imagee({required this.path});
}

// Form screen
class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  List<Imagee> _images = [];

  void _addImage(String path) {
    setState(() {
      _images.add(Imagee(path: path));
    });
  }

  void _deleteImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      // Save form data and images to database
      FormImages form = FormImages(title: _title, images: _images);
      // Save form to database
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Title',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
              onSaved: (value) {
                _title = value!;
              },
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  height: 300,
                  width: 280,
                  child: GridView.builder(
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
                    itemCount: _images.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        child: Image.file(File(_images[index].path)),
                        onTap: () => _deleteImage(index),
                      );
                    },
                  ),
                  /*ListView.builder(
                    itemCount: _images.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Image.file(File(_images[index].path));
                    },
                  ),*/
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerRight,
                  onPressed: () async {
                    await availableCameras().then((value) async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Cam(onPictureTaken: _addImage, cameras: value),
                        ),
                      );
                    });
                  },
                  icon: Icon(
                    Icons.camera_alt,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _images.length,
                itemBuilder: (BuildContext context, int index) {
                  return Image.file(File(_images[index].path));
                },
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // Navigate to screen where user can take pictures
                await availableCameras().then((value) async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Cam(onPictureTaken: _addImage, cameras: value),
                    ),
                  );
                });
              },
              child: Text('Take Picture'),
            ),
            ElevatedButton(
              onPressed: _saveForm,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}*/
