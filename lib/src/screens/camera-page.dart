import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/src/database/database-helper.dart';
import 'package:flutter_application/src/models/position-details-model.dart';
import 'package:flutter_application/src/models/position-model.dart';
import 'package:flutter_application/src/repositories/position-details-repository.dart';
import 'package:flutter_application/src/repositories/position-repository.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CameraPage extends StatefulWidget {
  final List<CameraDescription>? cameras;
  final LatLng? tappedPoint;

  const CameraPage({this.cameras, this.tappedPoint, Key? key})
      : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController controller;
  XFile? pictureFile;

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

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const SizedBox(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: SizedBox(
            child: CameraPreview(controller),
            //height: 400,
            //width: 400,
          )),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            child: const Text("take image"),
            onPressed: () async {
              pictureFile = await controller.takePicture();
              GallerySaver.saveImage(pictureFile!.path);
              print(pictureFile!.path);
              //
              PositionModel p =
                  await positionRepository.getPositionByLatAndLong(
                      widget.tappedPoint!.latitude.toString(),
                      widget.tappedPoint!.longitude.toString());
              print("details : ${p.toString()}");
              positionDetailsRepository.addPositionDetails(
                  PositionDetailsModel(
                      position_id: p.id, image: pictureFile!.path.toString()),
                  p);

              /*DatabaseHelper().addPosition(
                  widget.adresse.toString(),
                  widget.description.toString(),
                  widget.tappedPoint!.latitude.toString(),
                  widget.tappedPoint!.longitude.toString(),
                  pictureFile!.path.toString());*/
              print("table position");
              DatabaseHelper()
                  .showPositions()
                  .then((value) => print("$value\n"));
              // /data/user/0/com.example.flutter_application/cache/nom_fich.jpg
              setState(() {});
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("close"),
          ),
        ),
        // to show the image
        //if (pictureFile != null) Image.file(File(pictureFile!.path))
        /*Image.network(
            pictureFile!.path,
            height: 200,
          )*/
      ],
    );
  }
}
