import 'package:flutter/material.dart';
import 'package:flutter_application/src/api-services/SharedPreference.dart';
import 'package:flutter_application/src/models/ParcelleModel.dart';
import 'package:flutter_application/src/models/TypeRoleEnum.dart';
import 'package:flutter_application/src/models/observation-model.dart';
import 'package:flutter_application/src/models/user-model.dart';
import 'package:flutter_application/src/repositories/parcelle-repository.dart';
import 'package:flutter_application/src/repositories/observation-repository.dart';
import 'package:flutter_application/src/screens/modifier-observation.dart';
import 'package:flutter_application/src/screens/nouvelle-observation.dart';
import 'package:flutter_application/src/widget/my-popup-marker.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';
import 'package:dart_jts/dart_jts.dart' as jts;
import 'package:location/location.dart';

class ListObservations extends StatefulWidget {
  const ListObservations({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ListObservationsState();
}

class _ListObservationsState extends State<ListObservations> {
  late final MapController _mapController;
  LocationData? _currentLocation;
  Location? _locationService = Location();
  final PopupController _popupLayerController = PopupController();
  final PopupController _popupLayerController2 = PopupController();
  final PopupController _popupLayerController3 = PopupController();
  List<Marker> allMarkers = [];
  List<Marker> markers = [];
  Marker? myPosition;

  List<ParcelleModel> _parcelles = [];
  ParcelleModel? _selectedParcelle;
  List<LatLng> multipolygon = [];

  @override
  void initState() {
    _mapController = MapController();
    _loadParcelles();
    super.initState();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des observations'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              zoom: 5.0,
              onTap: (tapPosition, point) {
                _popupLayerController.hideAllPopups();
                _popupLayerController2.hideAllPopups();
                _popupLayerController3.hideAllPopups();
                if (_selectedParcelle != null) {
                  markers.clear();
                  if (myPosition != null) {
                    markers.add(myPosition!);
                  }
                  markers.add(
                    Marker(
                      rotate: false,
                      width: 30.0,
                      height: 30.0,
                      point: point,
                      builder: (ctx) => Icon(
                        Icons.location_on,
                        color: Colors.red,
                      ),
                    ),
                  );
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              ),
              if (multipolygon != null)
                PolygonLayer(polygons: [
                  Polygon(
                    points: multipolygon,
                    color: Colors.blue.withOpacity(0.2),
                    borderStrokeWidth: 3,
                  ),
                ]),
              MarkerLayer(
                markers: allMarkers,
              ),
              if (myPosition != null)
                MarkerLayer(
                  markers: [myPosition!],
                ),
              PopupMarkerLayerWidget(
                options: PopupMarkerLayerOptions(
                  popupController: _popupLayerController,
                  markers: markers,
                  markerRotateAlignment:
                      PopupMarkerLayerOptions.rotationAlignmentFor(
                          AnchorAlign.top),
                  popupBuilder: (BuildContext context, Marker marker) =>
                      GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      _popupLayerController.hideAllPopups();
                      _popupLayerController2.hideAllPopups();
                      setState(() {});
                    },
                    child: MyPopupMarker(
                      titre: "Nouvelle observation",
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NouvelleObservation(
                                latLng: marker.point,
                                parcelle: _selectedParcelle!),
                          ),
                        );
                        if (result == true) {
                          allMarkers.add(
                            Marker(
                              rotate: false,
                              width: 30.0,
                              height: 30.0,
                              point: marker.point,
                              builder: (ctx) => Icon(
                                Icons.remove_red_eye,
                                color: Colors.red,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
              PopupMarkerLayerWidget(
                options: PopupMarkerLayerOptions(
                  popupController: _popupLayerController2,
                  markers: allMarkers,
                  markerRotateAlignment:
                      PopupMarkerLayerOptions.rotationAlignmentFor(
                          AnchorAlign.top),
                  popupBuilder: (BuildContext context, Marker marker) =>
                      GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      _popupLayerController.hideAllPopups();
                      _popupLayerController2.hideAllPopups();
                      setState(() {});
                    },
                    child: MyPopupMarker(
                      titre: "Modifier observation",
                      onPressed: () async {
                        ObservationModel? observation =
                            await ObservationRepository().getByLatLng(
                                marker.point.latitude.toString(),
                                marker.point.longitude.toString(),
                                context);
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ModifierObservation(
                              observation: observation!,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              /*if (myPosition != null)
                PopupMarkerLayerWidget(
                  options: PopupMarkerLayerOptions(
                    popupController: _popupLayerController3,
                    markers: [myPosition!],
                    markerRotateAlignment:
                        PopupMarkerLayerOptions.rotationAlignmentFor(
                            AnchorAlign.top),
                    popupBuilder: (BuildContext context, Marker marker) =>
                        GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        _popupLayerController.hideAllPopups();
                        _popupLayerController2.hideAllPopups();
                        setState(() {});
                      },
                      child: MyPopupMarker(
                        titre: "Nouvelle observation",
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NouvelleObservation(
                                  latLng: marker.point,
                                  parcelle: _selectedParcelle!),
                            ),
                          );
                          if (result == true) {
                            allMarkers.add(
                              Marker(
                                rotate: false,
                                width: 30.0,
                                height: 30.0,
                                point: marker.point,
                                builder: (ctx) => Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
            */
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.all(20.0),
              color: Colors.white60,
              width: 250.0,
              child: DropdownButtonFormField<ParcelleModel>(
                value: _selectedParcelle,
                hint: Text('Sélectionner un lot'),
                items: _parcelles.map((ParcelleModel parcelle) {
                  return DropdownMenuItem<ParcelleModel>(
                    value: parcelle,
                    child: Text(parcelle.nom!),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedParcelle = newValue;
                    _loadSelectedParcelle(newValue);
                    _loadObservations();
                  });
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _getLocation();
        },
        child: Icon(Icons.my_location),
      ),
    );
  }

  _loadParcelles() async {
    UserModel? user = await SharedPreference().getUser();
    /*if (user?.roles?.first.type == TypeRoleEnum.ADMIN) {
      List<ParcelleModel>? list = await ParcelleRepository().getAllParcelles();
      _parcelles = list!;
    } else {
      List<ParcelleModel> list =
          await ParcelleRepository().getByUser(user!.id!, context);
      _parcelles = list;
    }*/
    setState(() {});
  }

  _loadSelectedParcelle(ParcelleModel? parcelle) {
    List<List<List<double>>> coordinates = [];
    String polygonString = parcelle!.geometry
        .toString()
        .replaceAll("MULTIPOLYGON (((", "")
        .replaceAll(")))", "");
    List<String> polygons = polygonString.split("), (");
    for (var p in polygons) {
      List<List<double>> points = [];
      p.split(", ").forEach((c) {
        List<double> point = c.split(" ").map((e) => double.parse(e)).toList();
        points.add(point);
      });
      coordinates.add(points);
    }
    List<List<LatLng>> points = [];
    for (var p in coordinates) {
      List<LatLng> polyPoints = [];
      for (var c in p) {
        polyPoints.add(LatLng(c[1], c[0]));
      }
      points.add(polyPoints);
    }
    setState(() {
      multipolygon = points[0];
      var center = _calculateCentroid(multipolygon);
      _mapController.move(center, 16.5);
    });
  }

  LatLng _calculateCentroid(List<LatLng> polygon) {
    double latitude = 0;
    double longitude = 0;
    int n = polygon.length;
    for (var i = 0; i < n; i++) {
      latitude += polygon[i].latitude;
      longitude += polygon[i].longitude;
    }
    return LatLng(latitude / n, longitude / n);
  }

  _loadObservations() async {
    if (_selectedParcelle != null) {
      List<ObservationModel>? observations = await ObservationRepository()
          .getAllObservations(_selectedParcelle!.id!, context);
      for (var element in observations!) {
        allMarkers.add(
          Marker(
            rotate: false,
            width: 40.0,
            height: 40.0,
            point: LatLng(double.parse(element.latitude.toString()),
                double.parse(element.longitude.toString())),
            builder: (ctx) => Icon(
              Icons.remove_red_eye,
              color: Colors.red,
            ),
          ),
        );
      }
      setState(() {});
    }
  }

  Future<void> _getLocation() async {
    try {
      bool serviceEnabled;
      PermissionStatus permissionGranted;

      serviceEnabled = await _locationService!.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _locationService!.requestService();
        if (!serviceEnabled) {
          return;
        }
      }

      permissionGranted = await _locationService!.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await _locationService!.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return;
        }
      }

      LocationData locationData = await _locationService!.getLocation();
      setState(() {
        _currentLocation = locationData;
      });
      myPosition = Marker(
        rotate: false,
        width: 30.0,
        height: 30.0,
        point: LatLng(
          _currentLocation!.latitude!,
          _currentLocation!.longitude!,
        ),
        builder: (ctx) => Container(
          child: IconButton(
            icon: Icon(Icons.location_on),
            color: Colors.blue,
            onPressed: () {
              print("tap");
            },
          ),
        ),
      );
      setState(() {});
    } catch (e) {
      print(e.toString());
    }
  }
}
