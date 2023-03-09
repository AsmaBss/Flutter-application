import 'package:camera/camera.dart';
import 'package:clippy_flutter/triangle.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/position-model.dart';
import 'package:flutter_application/src/repositories/position-details-repository.dart';
import 'package:flutter_application/src/repositories/position-repository.dart';
import 'package:flutter_application/src/screens/camera-page.dart';
import 'package:flutter_application/src/screens/totest.dart';
import 'package:flutter_application/src/widget/my-drawer.dart';
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
  List images = [];

  final _formKey = GlobalKey<FormState>();
  TextEditingController numero = TextEditingController();
  TextEditingController descr = TextEditingController();

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
                      //_showInfoWinfow(tappedPoint, adresse.toString(), description.toString());
                      // Form
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Stack(
                                //overflow: Overflow.visible,
                                children: <Widget>[
                                  Positioned(
                                    right: -40.0,
                                    top: -40.0,
                                    child: InkResponse(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: CircleAvatar(
                                        child: Icon(Icons.close),
                                        backgroundColor: Colors.red,
                                      ),
                                    ),
                                  ),
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: TextFormField(),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: TextFormField(),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton(
                                            child: Text("Submitß"),
                                            onPressed: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                _formKey.currentState!.save();
                                              }
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });

                      //setState(() {});
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
    //_showInfoWinfow(tappedPoint, adresse.toString(), description.toString());
    _showForm(tappedPoint, adresse.toString(), description.toString());
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
                          child: Icon(Icons.camera_alt),
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

  _showForm(LatLng tappedPoint, String adresse, String description) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.only(left: 65, right: 65),
          scrollable: true,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 0.0, top: 0.0),
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        alignment: FractionalOffset.topRight,
                        child: GestureDetector(
                          child: Icon(
                            Icons.clear,
                            color: Colors.red,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5),
                child: Text(
                  adresse.toString(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  softWrap: false,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5),
                child: Text(
                  description.toString(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: Form(
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: numero,
                  decoration: InputDecoration(
                    labelText: 'Number',
                  ),
                ),
                TextFormField(
                  controller: descr,
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: TextButton.icon(
                    onPressed: () {
                      _launchCamera(tappedPoint);
                    },
                    icon: Icon(Icons.camera_alt),
                    label: Text("Take picture"),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              child: Text("Submit"),
              onPressed: () async {
                print("images 2 ==> ${images.toString()}");
                print("numero ==> ${numero.text}");
                print("descr ==> ${descr.text}");
                // Save into database
              },
            ),
          ],
        );
      },
    );
  }

  _launchCamera(LatLng tappedPoint) async {
    await availableCameras().then((value) async {
      images = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              totest(cameras: value, tappedPoint: tappedPoint),
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
