import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:clippy_flutter/triangle.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/src/repositories/position-repository.dart';
import 'package:flutter_application/src/screens/camera-page.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Maps extends StatefulWidget {
  const Maps({Key? key}) : super(key: key);

  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
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
                // save position into database
                /*positionRepository.addPosition(PositionModel(
                    addresse: adresse,
                    description: description,
                    latitude: tappedPoint.latitude.toString(),
                    longitude: tappedPoint.longitude.toString()));*/
                //save position into local
                /*DatabaseHelper().addPosition(
                    adresse.toString(),
                    description.toString(),
                    tappedPoint.latitude.toString(),
                    tappedPoint.longitude.toString());
                DatabaseHelper()
                    .showPositions()
                    .then((value) => print("local ==> $value\n"));*/
                // add marker
                this.allMarkers.add(Marker(
                    markerId: MarkerId(tappedPoint.toString()),
                    position: tappedPoint,
                    draggable: false,
                    onTap: () {
                      _showInfoWinfow(tappedPoint, adresse.toString(),
                          description.toString());
                    }));
                setState(() {});
                print(allMarkers);
              }),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 240, //200
            width: 210, //200
            offset: 50,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Text('App name'),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  _getAddressFromPosition(LatLng tappedPoint) async {
    var addresses = await Geocoder.local.findAddressesFromCoordinates(
        Coordinates(tappedPoint.latitude, tappedPoint.longitude));
    var first = addresses.first;
    adresse = "${first.locality}, ${first.adminArea}, ${first.countryName}";
    description = first.addressLine;
    print("addresse 1 ==> $adresse");
    print("description 1 ===> $description");
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
                          onPressed: () {
                            print("save into database");
                            /*DatabaseHelper()
                                .showPositionByLatAndLng(
                                    tappedPoint.latitude.toString(),
                                    tappedPoint.longitude.toString())
                                .then((value) => {
                                      if (value != null)
                                        {
                                          print("value : $value"),
                                          print(
                                              "value.length : ${value.length}"),
                                          value.forEach((item) {
                                            print('element');
                                            print(item['addresse']);
                                            var addresse = item['addresse'];
                                            var description =
                                                item['description'];
                                            var latitude = item['latitude'];
                                            var longitude = item['longitude'];
                                            var image = item['image'];
                                            print(addresse);
                                            print(description);
                                            print(latitude);
                                            print(longitude);
                                            print(image);
                                            _addPosition(PositionModel(
                                                addresse: addresse.toString(),
                                                description:
                                                    description.toString(),
                                                latitude: latitude.toString(),
                                                longitude: longitude.toString(),
                                                image: image.toString()));
                                            print("added to database");
                                            /*DatabaseHelper().deletePosition(
                                                PositionModel(
                                                    addresse: addresse,
                                                    description: description,
                                                    latitude: latitude,
                                                    longitude: longitude,
                                                    image: image));
                                            print("deleted from local");*/
                                          }),
                                          print(value),
                                        }
                                    });
                          */
                          },
                          child: Text('Save Position'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _launchCamera(tappedPoint);
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
    positions.forEach((element) {
      LatLng tappedPoint = LatLng(
          double.parse(element.latitude), double.parse(element.longitude));
      this.allMarkers.add(
            Marker(
              markerId: MarkerId(tappedPoint.toString()),
              position: tappedPoint,
              draggable: false,
              onTap: () {
                _getAddressFromPosition(tappedPoint);
              },
            ),
          );
    });
    setState(() {});
  }
}
