import 'dart:async';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:clippy_flutter/triangle.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/src/database/database-helper.dart';
import 'package:flutter_application/src/models/position-model.dart';
import 'package:flutter_application/src/repositories/position-repository.dart';
import 'package:flutter_application/src/screens/camera-page.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Maps extends StatefulWidget {
  const Maps({Key? key}) : super(key: key);

  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  final PositionRepository repository = PositionRepository();

  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  List myMarkers = [];
  Position? _currentPosition;

  static const CameraPosition _cameraPosition = CameraPosition(
    target: LatLng(33.9871301997601, 9.64087277564642),
    zoom: 7.1,
  );

  @override
  void initState() {
    super.initState();
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
              initialCameraPosition: _cameraPosition,
              mapType: MapType.satellite,
              myLocationEnabled: true,
              compassEnabled: true,
              markers: Set.from(myMarkers),
              onCameraMove: (position) {
                _customInfoWindowController.onCameraMove!();
              },
              onMapCreated: (GoogleMapController controller) {
                _customInfoWindowController.googleMapController = controller;
              },
              onTap: (LatLng tappedPoint) async {
                _customInfoWindowController.hideInfoWindow!();
                _getCurrentPosition();
                setState(() {
                  myMarkers.add(Marker(
                      markerId: MarkerId(tappedPoint.toString()),
                      position: tappedPoint,
                      draggable: false,
                      onTap: () {
                        _getAddressFromPosition(tappedPoint);
                      }));
                  print(myMarkers);
                });
              }),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 240, //200
            width: 210, //200
            offset: 50,
          ),
        ],
      ),
    );
  }

  void _getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print("current position = $_currentPosition");
  }

  void _getAddressFromPosition(LatLng tappedPoint) async {
    var addresses = await Geocoder.local.findAddressesFromCoordinates(
        Coordinates(tappedPoint.latitude, tappedPoint.longitude));
    var first = addresses.first;
    print(
        "address : ${first.locality}, ${first.adminArea}, ${first.countryName}");
    print("description : ${first.addressLine}");
    String adresse =
        "${first.locality}, ${first.subLocality}, ${first.adminArea}, ${first.countryName}";
    String description = first.addressLine;
    _showInfoWinfow(tappedPoint, adresse, description);
  }

  void _showInfoWinfow(LatLng tappedPoint, String adresse, String description) {
    _customInfoWindowController.addInfoWindow!(
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        adresse,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            print("save into database");
                            DatabaseHelper()
                                .showPositionByLatAndLng(
                                    tappedPoint.latitude.toString(),
                                    tappedPoint.longitude.toString())
                                .then((value) => {
                                      if (value != null)
                                        {
                                          print(value),
                                          value.forEach((item) {
                                            print('element');
                                            print(item['addresse']);
                                            var addresse = item['addresse'];
                                            var description =
                                                item['description'];
                                            var latitude = item['latitude'];
                                            var longitude = item['longitude'];
                                            var image = item['image'];
                                            _addPosition(PositionModel(
                                                addresse: addresse,
                                                description: description,
                                                latitude: latitude,
                                                longitude: longitude,
                                                image: image));
                                          })
                                        }
                                    });
                          },
                          child: Text('Save Position'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _launchCamera(adresse, description, tappedPoint);
                          },
                          child: Icon(Icons.camera),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Triangle.isosceles(
              edge: Edge.BOTTOM,
              child: Container(
                color: Colors.white70,
                width: 25,
                height: 15,
              ),
            ),
          ],
        ),
        tappedPoint);
  }

  void _addPosition(PositionModel p) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      repository.addPosition(p);
    } else {
      /*DatabaseHelper().addPosition(addresse.toString(), description.toString(),
          latitude.toString(), longitude.toString());
      print("table avant truncate");
      DatabaseHelper().showPositions().then((value) => print(value));
      //DatabaseHelper().truncateTable();
      print("table après truncate");
      DatabaseHelper().showPositions().then((value) => print(value));*/
    }
  }

  void _launchCamera(
      String adresse, String description, LatLng tappedPoint) async {
    await availableCameras().then((value) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CameraPage(
              cameras: value,
              adresse: adresse,
              description: description,
              tappedPoint: tappedPoint),
        ),
      );
    });
  }
}
