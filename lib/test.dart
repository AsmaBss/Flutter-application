import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
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
class FormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  List<Imagee> _images = [];

  void _addImage(String path) {
    setState(() {
      _images.add(Imagee(path: path));
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
          children: [
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
                      builder: (context) => TakePictureScreen(
                          onPictureTaken: _addImage, cameras: value),
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
}

// Take picture screen
class TakePictureScreen extends StatefulWidget {
  final Function(String) onPictureTaken;
  final List<CameraDescription> cameras;

  TakePictureScreen({required this.onPictureTaken, required this.cameras});

  @override
  _TakePictureScreenState createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _cameraController;
  late Future<void> _cameraInitialized;

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(
      // Use the first available camera
      widget.cameras[0],
      ResolutionPreset.medium,
    );
    _cameraInitialized = _cameraController.initialize();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      // Take the picture
      XFile file = await _cameraController.takePicture();

      // Return the path to the picture file
      widget.onPictureTaken(file.path);

      // Pop the screen off the navigation stack
      Navigator.pop(context);
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  late File _imageFile;

  /*Future<void> _takePicture() async {
    final imageFile = await ImagePicker().getImage(source: ImageSource.camera);
    setState(() {
      _imageFile = File(imageFile!.path);
    });
    widget.onPictureTaken(imageFile!.path);
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _cameraInitialized,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                CameraPreview(_cameraController),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: _takePicture,
                      child: Text('Take Picture'),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
