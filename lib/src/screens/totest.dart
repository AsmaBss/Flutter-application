import 'dart:io';
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/position-details-model.dart';
import 'package:flutter_application/src/models/position-model.dart';
import 'package:flutter_application/src/repositories/position-details-repository.dart';
import 'package:flutter_application/src/repositories/position-repository.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:path_provider/path_provider.dart';

class totest extends StatefulWidget {
  final List<CameraDescription>? cameras;
  final LatLng? tappedPoint;

  const totest({this.cameras, this.tappedPoint, Key? key}) : super(key: key);

  @override
  State<totest> createState() => _totestState();
}

class _totestState extends State<totest> {
  late CameraController controller;
  XFile? pictureFile;
  List images = [];

  PositionRepository positionRepository = PositionRepository();
  PositionDetailsRepository positionDetailsRepository =
      PositionDetailsRepository();

  @override
  void initState() {
    super.initState();
    controller = CameraController(
      widget.cameras![0],
      ResolutionPreset.max,
    );
    controller.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<File> saveImage(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File("${directory.path}/$name");
    return File(imagePath).copy(image.path);
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      //crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(0.0),
          child: CameraPreview(controller),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                TextButton(
                  child: Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                    size: 40,
                  ),
                  onPressed: () {
                    Navigator.pop(context, images);
                  },
                ),
                FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: () async {
                    await controller.setFlashMode(FlashMode.off);
                    // Take picture
                    pictureFile = await controller.takePicture();
                    //
                    final imagePermanent = await saveImage(pictureFile!.path);
                    print("imagePermanent ===> ${imagePermanent.toString()}");
                    //
                    GallerySaver.saveImage(imagePermanent.path).then((path) => {
                          setState(() {
                            print("Gallery saver ===> $path");
                          }),
                        });
                    images.add(imagePermanent.path.toString());
                    print("images 1 ===> ${images.toString()}");

                    // /data/user/0/com.example.flutter_application/cache/nom_fich.jpg
                    setState(() {});
                  },
                  child: Icon(
                    Icons.camera,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
