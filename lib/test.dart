import 'package:camera/camera.dart';
import 'package:clippy_flutter/triangle.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/position-model.dart';
import 'package:flutter_application/src/repositories/position-repository.dart';
import 'package:flutter_application/src/screens/camera-page.dart';
import 'package:flutter_application/src/widget/my-drawer.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  final PositionRepository positionRepository = PositionRepository();

  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  List<Marker> allMarkers = [];
  String? adresse, description;

  static const CameraPosition _cameraPosition = CameraPosition(
    target: LatLng(33.9871301997601, 9.64087277564642),
    zoom: 7.1,
  );

  @override
  void initState() {
    super.initState();
    _loadMarkers();
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
              markers: Set<Marker>.of(allMarkers),
              onCameraMove: (position) {
                _customInfoWindowController.onCameraMove!();
              },
              onMapCreated: (GoogleMapController controller) {
                _customInfoWindowController.googleMapController = controller;
              },
              onTap: (LatLng tappedPoint) async {
                _customInfoWindowController.hideInfoWindow!();
                // Get address from coordinates
                var addresses = await Geocoder.local
                    .findAddressesFromCoordinates(Coordinates(
                        tappedPoint.latitude, tappedPoint.longitude));
                var first = addresses.first;
                adresse =
                    "${first.locality}, ${first.adminArea}, ${first.countryName}";
                description = first.addressLine;
                // Add marker
                allMarkers.add(Marker(
                    markerId: MarkerId(tappedPoint.toString()),
                    position: tappedPoint,
                    draggable: false,
                    onTap: () async {
                      // Save position into database
                      PositionRepository().addPosition(
                          PositionModel(
                              addresse: adresse.toString(),
                              description: description.toString(),
                              latitude: tappedPoint.latitude.toString(),
                              longitude: tappedPoint.longitude.toString()),
                          context);
                      // Show InfoWindow
                      _showInfoWinfow(tappedPoint, adresse.toString(),
                          description.toString());
                    }));
                setState(() {});
              }),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 240, //200
            width: 210, //200
            offset: 50,
          ),
        ],
      ),
      drawer: MyDrawer(),
    );
  }

  _getAddressFromPosition(LatLng tappedPoint) async {
    var addresses = await Geocoder.local.findAddressesFromCoordinates(
        Coordinates(tappedPoint.latitude, tappedPoint.longitude));
    var first = addresses.first;
    adresse = "${first.locality}, ${first.adminArea}, ${first.countryName}";
    description = first.addressLine;
    _showInfoWinfow(tappedPoint, adresse.toString(), description.toString());
  }

  _showInfoWinfow(LatLng tappedPoint, String adresse, String description) {
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
                        adresse.toString(),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        description.toString(),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          child: Text('Save Position'),
                          onPressed: () {
                            // form
                          },
                        ),
                        ElevatedButton(
                          child: Icon(Icons.camera),
                          onPressed: () {
                            _launchCamera(tappedPoint);
                          },
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

  _launchCamera(LatLng tappedPoint) async {
    await availableCameras().then((value) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              CameraPage(cameras: value, tappedPoint: tappedPoint),
        ),
      );
    });
  }

  _loadMarkers() async {
    List positions = await positionRepository.getAllPositions(context);
    for (var element in positions) {
      LatLng tappedPoint = LatLng(
          double.parse(element.latitude), double.parse(element.longitude));
      allMarkers.add(
        Marker(
          markerId: MarkerId(tappedPoint.toString()),
          position: tappedPoint,
          draggable: false,
          onTap: () {
            _getAddressFromPosition(tappedPoint);
          },
        ),
      );
    }
    setState(() {});
  }
}
