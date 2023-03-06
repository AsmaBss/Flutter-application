import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
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
                    Navigator.pop(context);
                  },
                ),
                FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: () async {
                    await controller.setFlashMode(FlashMode.off);
                    // Get position by lat and long
                    PositionModel p =
                        await positionRepository.getPositionByLatAndLong(
                            widget.tappedPoint!.latitude.toString(),
                            widget.tappedPoint!.longitude.toString(),
                            context);
                    print("Get position by lat and long ===> ${p.toString()}");
                    // Take picture
                    pictureFile = await controller.takePicture();
                    // Save picture in gallery
                    GallerySaver.saveImage(pictureFile!.path,
                            albumName: "Pictures")
                        .then((path) => {
                              setState(() {
                                print("Gallery saver ===> $path");
                              }),
                            });
                    print(pictureFile!.path);
                    // Save into database
                    positionDetailsRepository.addPositionDetails(
                        PositionDetailsModel(
                            position_id: p.id,
                            image: pictureFile!.path.toString()),
                        p,
                        context);
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

    /*
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: CameraPreview(controller),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: EdgeInsets.zero,
              child: ElevatedButton(
                child: Icon(
                  Icons.circle_rounded,
                  color: Colors.green,
                ),
                onPressed: () async {
                  // Get position by lat and long
                  PositionModel p =
                      await positionRepository.getPositionByLatAndLong(
                          widget.tappedPoint!.latitude.toString(),
                          widget.tappedPoint!.longitude.toString(),
                          context);
                  print("Get position by lat and long ===> ${p.toString()}");
                  // Take picture
                  await controller.setFlashMode(FlashMode.off);
                  pictureFile = await controller.takePicture();
                  // Save picture in gallery
                  GallerySaver.saveImage(pictureFile!.path).then((path) => {
                        setState(() {
                          print("Gallery saver ===> $path");
                        }),
                      });
                  print(pictureFile!.path);
                  // Save into database
                  positionDetailsRepository.addPositionDetails(
                      PositionDetailsModel(
                          position_id: p.id,
                          image: pictureFile!.path.toString()),
                      p,
                      context);
                  // /data/user/0/com.example.flutter_application/cache/nom_fich.jpg
                  setState(() {});
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                child: const Text("close"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
        // to show the image
        //if (pictureFile != null) Image.file(File(pictureFile!.path))
        /*Image.network(
            pictureFile!.path,
            height: 200,
          )*/
      ],
    );
  */
  }
}
