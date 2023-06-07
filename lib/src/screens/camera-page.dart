import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CameraPage extends StatefulWidget {
  final Function(String) onPictureTaken;
  final List<CameraDescription> cameras;

  CameraPage({required this.onPictureTaken, required this.cameras});

  @override
  State<StatefulWidget> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _cameraController;
  late Future<void> _cameraInitialized;

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(
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
      await _cameraController.setFlashMode(FlashMode.off);
      XFile file = await _cameraController.takePicture();
      final bytes = File(file.path).readAsBytesSync();
      String img64 = base64Encode(bytes);
      widget.onPictureTaken(img64);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _cameraInitialized,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                SizedBox(
                  height: double.infinity,
                  child: CameraPreview(_cameraController),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.150,
                    decoration: const BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(24)),
                        color: Colors.black),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              iconSize: 30,
                              icon: Icon(CupertinoIcons.left_chevron,
                                  color: Colors.white),
                              onPressed: () {
                                Navigator.pop(context);
                                setState(() {});
                              },
                            ),
                          ),
                          Expanded(
                            child: IconButton(
                              onPressed: _takePicture,
                              iconSize: 50,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon:
                                  const Icon(Icons.circle, color: Colors.white),
                            ),
                          ),
                          const Spacer(),
                        ]),
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
