import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/src/database/images-query.dart';
import 'package:flutter_application/src/database/position-details-query.dart';
import 'package:flutter_application/src/models/position-model.dart';
import 'package:flutter_application/src/repositories/position-repository.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Cam extends StatefulWidget {
  final List<CameraDescription>? cameras;
  final LatLng point;

  const Cam({Key? key, required this.cameras, required this.point})
      : super(key: key);

  @override
  State<Cam> createState() => _CamState();
}

class _CamState extends State<Cam> {
  late CameraController _cameraController;

  @override
  void initState() {
    super.initState();
    // initialize the rear camera
    initCamera(widget.cameras![0]);
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        (_cameraController.value.isInitialized)
            ? CameraPreview(_cameraController)
            : Container(
                color: Colors.black,
                child: const Center(child: CircularProgressIndicator())),
        Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.20,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  color: Colors.black),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Expanded(
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: 30,
                    icon:
                        Icon(CupertinoIcons.left_chevron, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {});
                    },
                  ),
                ),
                Expanded(
                  child: IconButton(
                    onPressed: () => takePicture(context),
                    iconSize: 50,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.circle, color: Colors.white),
                  ),
                ),
                const Spacer(),
              ]),
            )),
      ]),
    );
  }

  Future initCamera(CameraDescription cameraDescription) async {
    // create a CameraController
    _cameraController = CameraController(
        cameraDescription, ResolutionPreset.high,
        enableAudio: false);
    // Next, initialize the controller. This returns a Future.
    try {
      await _cameraController.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }

  Future takePicture(BuildContext context) async {
    if (!_cameraController.value.isInitialized) {
      return null;
    }
    if (_cameraController.value.isTakingPicture) {
      return null;
    }
    try {
      // Take picture
      await _cameraController.setFlashMode(FlashMode.off);
      XFile picture = await _cameraController.takePicture();
      final bytes = File(picture.path).readAsBytesSync();
      String img64 = base64Encode(bytes);
      print("bytes $bytes");
      print("img64 $img64");
      // Save Image Permamently
      //final imagePermanent = await saveImage(picture.path);
      //print("imagePermanent ===> ${imagePermanent.toString()}");
      // Show local data
      ImagesQuery().showImages().then(
            (value) => {
              if (value.isNotEmpty)
                {print("item  -PosDet- ==> $value\n")}
              else
                {print("table empty")}
            },
          );
      // Save image
      //ImagesQuery().addImage(imagePermanent.path);
      print("1");
      ImagesQuery().addImage(img64);
      print("2");
    } on CameraException catch (e) {
      debugPrint('Error occured while taking picture: $e');
      return null;
    }
  }

  Future<File> saveImage(String imagePath) async {
    final external = await getExternalStorageDirectory();
    print("esternal => ${external.toString()}");
    final directory = await getApplicationDocumentsDirectory();
    print("directory => ${directory.toString()}");
    final name = basename(imagePath);
    print("name => ${name.toString()}");
    final image = File("${external!.path}/$name"); //directory
    print("image => ${image.path}");
    return File(imagePath).copy(image.path);
  }
}
