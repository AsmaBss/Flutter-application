import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:custom_info_window/custom_info_window.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Completer<GoogleMapController> _controller = Completer();
  List myMarker = [];
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  static final CameraPosition _kGoogle = const CameraPosition(
    target: LatLng(33.9871301997601, 9.64087277564642),
    zoom: 7.1,
  );

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });
    return await Geolocator.getCurrentPosition();
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
        backgroundColor: Color(0xFF0F9D58),
        title: Text("Maps"),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _kGoogle,
            mapType: MapType.normal,
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
              setState(() {
                myMarker = [];
                myMarker.add(Marker(
                  markerId: MarkerId(tappedPoint.toString()),
                  position: tappedPoint,
                  draggable: false,
                  onTap: () {
                    _customInfoWindowController.addInfoWindow!(
                        Container(
                          height: 150,
                          width: 200,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 10, right: 10),
                                child: SizedBox(
                                  width: 200,
                                  child: Text(
                                    '${first.locality}, ${first.subLocality} \n${first.adminArea}, ${first.subAdminArea}, ${first.countryName}',
                                    maxLines: 2,
                                    overflow: TextOverflow.visible,
                                    softWrap: false,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 10, right: 10),
                                child: Text(
                                  '${first.addressLine}',
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        tappedPoint);
                  },
                ));
              });
            },
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 150,
            width: 200,
            offset: 30,
          ),
        ],
      ),
    );
  }
}
