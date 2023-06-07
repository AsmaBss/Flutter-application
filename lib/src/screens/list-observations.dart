import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/ParcelleModel.dart';
import 'package:flutter_application/src/models/observation-model.dart';
import 'package:flutter_application/src/repositories/ParcelleRepository.dart';
import 'package:flutter_application/src/repositories/observation-repository.dart';
import 'package:flutter_application/src/screens/nouvelle-observation.dart';
import 'package:flutter_application/src/widget/drawer-widget.dart';
import 'package:flutter_application/src/widget/my-popup-marker.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';
import 'package:dart_jts/dart_jts.dart' as jts;

class ListObservations extends StatefulWidget {
  const ListObservations({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ListObservationsState();
}

class _ListObservationsState extends State<ListObservations> {
  late final MapController _mapController;
  final PopupController _popupLayerController = PopupController();
  List<Marker> allMarkers = [];
  List<Marker> markers = [];

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
        title: Text('Maps'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              zoom: 5.0,
              onTap: (tapPosition, point) {
                if (_selectedParcelle != null) {
                  _popupLayerController.hideAllPopups();
                  markers.clear();
                  markers.add(
                    Marker(
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
                    color: Colors.blue.withOpacity(0.3),
                    borderStrokeWidth: 3,
                  ),
                ]),
              MarkerLayer(
                markers: allMarkers,
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
                      setState(() {});
                    },
                    child: MyPopupMarker(
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
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
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
      drawer: MyDrawer(),
    );
  }

  _loadParcelles() async {
    List<ParcelleModel> list =
        await ParcelleRepository().getAllParcelles(context);
    _parcelles = list;
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
      List<ObservationModel> observations = await ObservationRepository()
          .getAllObservations(_selectedParcelle!.id!, context);
      for (var element in observations) {
        allMarkers.add(
          Marker(
            width: 30.0,
            height: 30.0,
            point: LatLng(double.parse(element.latitude.toString()),
                double.parse(element.longitude.toString())),
            builder: (ctx) => Icon(
              Icons.location_on,
              color: Colors.red,
            ),
          ),
        );
      }
      setState(() {});
    }
  }
}
