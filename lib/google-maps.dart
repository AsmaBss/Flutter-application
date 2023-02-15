import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application/camera-page.dart';
import 'package:flutter_application/src/database/mysql.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:clippy_flutter/triangle.dart';
import 'package:camera/camera.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final db = Mysql();
  String? address, description, latitude, longitude;
  List myMarker = [];
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  static const CameraPosition _kGoogle = CameraPosition(
    target: LatLng(33.9871301997601, 9.64087277564642),
    zoom: 7.1,
  );

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR$error");
    });
    return await Geolocator.getCurrentPosition();
  }

  // "SELECT * FROM position WHERE id = :id", {"id": 1}
  void _saveData() async {
    await db.getConnection().then((conn) async {
      await conn.connect();
      var sql =
          'INSERT INTO `project`.`position` (`address`, `description`,`latitude`, `longitude`) VALUES ("$address","$description","$latitude","$longitude");';
      print(sql);
      await conn.execute(sql).whenComplete(() {
        print("database closed");
        conn.close();
      });
    });
  }

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Maps"),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _kGoogle,
            mapType: MapType.satellite,
            myLocationEnabled: true,
            compassEnabled: true,
            markers: Set.from(myMarker),
            onCameraMove: (position) {
              _customInfoWindowController.onCameraMove!();
            },
            onMapCreated: (GoogleMapController controller) {
              //_controller.complete(controller);
              _customInfoWindowController.googleMapController = controller;
            },
            onTap: (LatLng tappedPoint) async {
              _customInfoWindowController.hideInfoWindow!();
              print(tappedPoint);
              var addresses = await Geocoder.local.findAddressesFromCoordinates(
                  Coordinates(tappedPoint.latitude, tappedPoint.longitude));
              var first = addresses.first;
              print(
                  '${first.locality}, ${first.adminArea}, ${first.countryName}, ${first.addressLine}, ${first.countryCode}, ${first.featureName}, ${first.postalCode}, ${first.thoroughfare}, ${first.subAdminArea}, ${first.subLocality}, ${first.subThoroughfare}');

              latitude = tappedPoint.latitude.toString();
              longitude = tappedPoint.longitude.toString();
              address =
                  '${first.locality}, ${first.adminArea}, ${first.countryName}';
              description = '${first.addressLine}';
              //${first.locality}, ${first.subLocality} \n${first.adminArea}, ${first.subAdminArea}, ${first.countryName}

              setState(() {
                myMarker = [];
                myMarker.add(Marker(
                  markerId: MarkerId(tappedPoint.toString()),
                  position: tappedPoint,
                  draggable: false,
                  onTap: () {
                    _customInfoWindowController.addInfoWindow!(
                        Column(
                          children: [
                            Expanded(
                              child: Container(
                                height: double.infinity,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    //border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: SizedBox(
                                        width: 200,
                                        child: Text(
                                          '${first.locality}, ${first.subLocality} \n${first.adminArea}, ${first.subAdminArea}, ${first.countryName}',
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        '${first.addressLine}',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: _saveData,
                                      child: Text('Press me!'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Triangle.isosceles(
                              edge: Edge.BOTTOM,
                              child: Container(
                                color: Colors.white,
                                width: 25,
                                height: 15,
                              ),
                            ),
                          ],
                        ),
                        tappedPoint);
                  },
                ));
              });
            },
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 200,
            width: 200,
            offset: 50,
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: ElevatedButton(
                  onPressed: () async {
                    await availableCameras().then((value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CameraPage(
                                    cameras: value,
                                  )));
                    });
                  },
                  child: Icon(Icons.camera)),
            ),
          )
        ],
      ),
    );
  }
}
