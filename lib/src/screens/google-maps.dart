import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application/src/api-services/position-api-services.dart';
import 'package:flutter_application/src/models/position-model.dart';
import 'package:flutter_application/src/screens/camera-page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:clippy_flutter/triangle.dart';
import 'package:camera/camera.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? addresse, description, latitude, longitude;
  List myMarker = [];
  final PositionApiServices api = PositionApiServices();

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

  void getAddressFromCoords(LatLng tappedPoint) async {
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
  }

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
                            'adress 1 ',
                            //${first.locality}, ${first.subLocality} \n${first.adminArea}, ${first.subAdminArea}, ${first.countryName}
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                          ),
                          Text(
                            'address2',
                            //${first.addressLine}
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () {
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
      api.addPosition(PositionModel(
          addresse: "flutter",
          description: "flutter",
          latitude: "flutter",
          longitude: "flutter"));
      //Navigator.pop(context);
    } else {
      print("No network");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //String encodedMap = json.encode(myMarker);
      //prefs.setString('marker', encodedMap);
      prefs.setString("latitude", tappedPoint.latitude.toString());
      prefs.setString("longitude", tappedPoint.longitude.toString());
    }
  }

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //String encodedMap = prefs.getString('marker')!;
    //List decodedMap = json.decode(encodedMap);
    //print('load data  = $decodedMap');
    String lat = prefs.getString('latitude')!;
    String long = prefs.getString('longitude')!;
    //print('load data  = $decodedMap');
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
              getAddressFromCoords(tappedPoint);
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
