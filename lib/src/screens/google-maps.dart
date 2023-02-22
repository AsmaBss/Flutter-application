import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application/src/api-services/api-services.dart';
import 'package:flutter_application/src/database/database-helper.dart';
import 'package:flutter_application/src/models/position-model.dart';
import 'package:flutter_application/src/repositories/position-repository.dart';
import 'package:flutter_application/src/screens/camera-page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:flutter_geocoder/geocoder.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:clippy_flutter/triangle.dart';
import 'package:camera/camera.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiServices api = ApiServices();
  final PositionRepository repository = PositionRepository();
  String? _currentAddress;
  Position? _currentPosition;

  String? addresse, description, latitude, longitude;

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

  /*void getAddressFromCoords(LatLng tappedPoint) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      var addresses = await Geocoder.local.findAddressesFromCoordinates(
          Coordinates(tappedPoint.latitude, tappedPoint.longitude));
      var first = addresses.first;
      print(
          '${first.locality}, ${first.adminArea}, ${first.countryName}, ${first.addressLine}, ${first.countryCode}, ${first.featureName}, ${first.postalCode}, ${first.thoroughfare}, ${first.subAdminArea}, ${first.subLocality}, ${first.subThoroughfare}');
      latitude = tappedPoint.latitude.toString();
      longitude = tappedPoint.longitude.toString();
      addresse = '${first.locality}, ${first.adminArea}, ${first.countryName}';
      description = '${first.addressLine}';
      //${first.locality}, ${first.subLocality} \n${first.adminArea}, ${first.subAdminArea}, ${first.countryName}
    } else {}
  }*/

  void _addMarkerAndCustomInfoWindow(LatLng tappedPoint) {
    setState(() {
      myMarker.add(Marker(
        markerId: MarkerId(tappedPoint.toString()),
        position: tappedPoint,
        draggable: false,
        onTap: () {
          _customInfoWindowController.addInfoWindow!(
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                          Text(
                            '$addresse',
                            //${first.locality}, ${first.subLocality} \n${first.adminArea}, ${first.subAdminArea}, ${first.countryName}
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                          ),
                          Text(
                            '$description',
                            //${first.addressLine}
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  saveData(tappedPoint);
                                },
                                child: Text('Save Position'),
                              ),
                              ElevatedButton(
                                  onPressed: launchCamera,
                                  child: Icon(Icons.camera)),
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
        },
      ));
    });
  }

  void launchCamera() async {
    await availableCameras().then((value) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CameraPage(
            cameras: value,
          ),
        ),
      );
    });
  }

  void saveData(LatLng tappedPoint) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      PositionModel p = new PositionModel();
      p.addresse = addresse;
      p.description = description;
      p.latitude = latitude;
      p.longitude = longitude;
      p.image = "test";
      repository.addPosition(p);
    } else {
      /*DatabaseHelper().addPosition(addresse.toString(), description.toString(),
          latitude.toString(), longitude.toString(), "");
      print("table avant truncate");
      DatabaseHelper().showPositions().then((value) => print(value));
      //DatabaseHelper().truncateTable();
      print("table après truncate");
      DatabaseHelper().showPositions().then((value) => print(value));*/
    }
  }

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
            initialCameraPosition: _kGoogle,
            mapType: MapType.satellite,
            myLocationEnabled: true,
            compassEnabled: true,
            markers: Set.from(myMarker),
            onCameraMove: (position) {
              _customInfoWindowController.onCameraMove!();
            },
            onMapCreated: (GoogleMapController controller) {
              _customInfoWindowController.googleMapController = controller;
            },
            onTap: (LatLng tappedPoint) async {
              _customInfoWindowController.hideInfoWindow!();
              print("addressFromCoords");
              //_getCurrentPosition();
              //getAddressFromCoords(tappedPoint);
              print("addMarkerandinfowindow");
              _addMarkerAndCustomInfoWindow(tappedPoint);
              print("all markers ---------------------------  $myMarker");
            },
          ),
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
}
