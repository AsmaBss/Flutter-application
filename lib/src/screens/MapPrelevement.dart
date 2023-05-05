import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/ParcelleModel.dart';
import 'package:flutter_application/src/models/PlanSondageModel.dart';
import 'package:flutter_application/src/models/PrelevementModel.dart';
import 'package:flutter_application/src/models/SecurisationModel.dart';
import 'package:flutter_application/src/repositories/PrelevementRepository.dart';
import 'package:flutter_application/src/screens/ModifierPrelevement.dart';
import 'package:flutter_application/src/screens/NouveauPrelevement.dart';
import 'package:flutter_application/src/screens/maps.dart';
import 'package:flutter_application/src/widget/ListPrelevementWidget.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geojson/geojson.dart';
import 'package:latlong2/latlong.dart';
import 'package:dart_jts/dart_jts.dart' as jts;

class MapPrelevement extends StatefulWidget {
  final List<PlanSondageModel?> planSondage;
  final ParcelleModel? parcelle;
  final SecurisationModel securisation;
  final bool leading;
  const MapPrelevement(
      {required this.planSondage,
      required this.parcelle,
      required this.securisation,
      required this.leading,
      Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _MapPrelevementState();
}

class _MapPrelevementState extends State<MapPrelevement>
    with AutomaticKeepAliveClientMixin<MapPrelevement> {
  List<Marker> allMarkers = [];
  late final MapController _mapController;
  LatLng? center;
  List<LatLng> multipolygon = [];
  List<Marker> markers = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _mapController = MapController();
    _loadParcelle();
    _loadPlanSondage();
    super.initState();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void refreshPage() {
    setState(() {
      _loadPlanSondage();
    });
  }

  @override
  Widget build(BuildContext context) {
    final polygon = Polygon(
      points: multipolygon,
      color: Colors.green.withOpacity(0.5),
      borderColor: Colors.red,
      borderStrokeWidth: 2,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Map  -  ${widget.securisation.nom}"),
        automaticallyImplyLeading: widget.leading,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Maps(),
              ));
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Flexible(
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  center: center,
                  zoom: 16.5, //5
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c'],
                  ),
                  PolygonLayer(polygons: [polygon]),
                  MarkerLayer(
                    markers: markers,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: ListPrelevementWidget(
        future: _fetchPlanSondageList(),
      ),
    );
  }

  _loadParcelle() {
    List<List<List<double>>> coordinates = [];
    String polygonString = widget.parcelle!.geometry
        .toString()
        .replaceAll("MULTIPOLYGON (((", "")
        .replaceAll(")))", "");
    List<String> polygons = polygonString.split("), (");
    polygons.forEach((p) {
      List<List<double>> points = [];
      p.split(", ").forEach((c) {
        List<double> point = c.split(" ").map((e) => double.parse(e)).toList();
        points.add(point);
      });
      coordinates.add(points);
    });
    List<List<LatLng>> points = [];
    coordinates.forEach((p) {
      List<LatLng> polyPoints = [];
      p.forEach((c) {
        polyPoints.add(LatLng(c[1], c[0]));
      });
      points.add(polyPoints);
    });
    multipolygon = points[0];
    center = _calculateCentroid(multipolygon);
  }

  _loadPlanSondage() async {
    List<String?> geometries = widget.planSondage
        .map((e) => e!.geometry
            .toString()
            .replaceAll("POINT (", "")
            .replaceAll(")", ""))
        .toList();
    List<List<List<double>>> coordinates = [];
    List<List<double>> list = [];
    geometries.forEach((e) {
      List<double> point = e!.split(" ").map((e) => double.parse(e)).toList();
      list.add(point);
    });
    coordinates.add(list);
    List<List<LatLng>> points = [];
    coordinates.forEach((p) {
      List<LatLng> list = [];
      p.forEach((c) {
        list.add(LatLng(c[1], c[0]));
      });
      points.add(list);
    });
    List<LatLng> multipoints = points[0];
    for (var point in multipoints) {
      String coord = "(${point.longitude}, ${point.latitude})";
      PrelevementModel? prelevement = await PrelevementRepository()
          .getPrelevementByPlanSondage(coord, context);
      if (prelevement == null) {
        markers.add(
          Marker(
            point: point,
            builder: (context) => GestureDetector(
              child: Icon(
                Icons.location_on,
                color: Colors.red,
              ),
              onTap: () => _addPrelevement(context, point),
            ),
          ),
        );
      } else {
        markers.add(
          Marker(
            point: point,
            builder: (context) => GestureDetector(
              child: Icon(
                Icons.location_on,
                color: Colors.green,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ModifierPrelevement(prelevement: prelevement),
                  ),
                );
              },
            ),
          ),
        );
      }
      setState(() {});
    }
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

  void _addPrelevement(BuildContext context, LatLng point) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            NouveauPrelevement(point: point, securisation: widget.securisation),
      ),
    );
    if (result == true) {
      refreshPage();
    }
  }

  Future<List<PlanSondageModel?>> _fetchPlanSondageList() async {
    final list =
        widget.planSondage.where((element) => element != null).toList();
    await Future.delayed(Duration(seconds: 1));
    return list;
  }
}
