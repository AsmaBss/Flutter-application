import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/ParcelleModel.dart';
import 'package:flutter_application/src/models/PlanSondageModel.dart';
import 'package:flutter_application/src/models/PrelevementModel.dart';
import 'package:flutter_application/src/models/SecurisationModel.dart';
import 'package:flutter_application/src/models/StatutEnum.dart';
import 'package:flutter_application/src/repositories/PrelevementRepository.dart';
import 'package:flutter_application/src/repositories/PlanSondageRepository.dart';
import 'package:flutter_application/src/screens/modifier-prelevement.dart';
import 'package:flutter_application/src/screens/nouveau-prelevement.dart';
import 'package:flutter_application/src/widget/drawer-widget.dart';
import 'package:flutter_application/src/widget/my-dialog.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:dart_jts/dart_jts.dart' as jts;

class MapPrelevement extends StatefulWidget {
  final List<PlanSondageModel?> planSondage;
  final ParcelleModel? parcelle;
  final SecurisationModel securisation;

  const MapPrelevement(
      {required this.planSondage,
      required this.parcelle,
      required this.securisation,
      Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _MapPrelevementState();
}

class _MapPrelevementState extends State<MapPrelevement>
    with AutomaticKeepAliveClientMixin<MapPrelevement> {
  List<Marker> allMarkers = [];
  late final MapController _mapController;
  List<LatLng> multipolygon = [];
  List<Marker> markers = [];
  LatLng? center;

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
      _fetchPlanSondageList();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("${widget.securisation.nom}"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, true);
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
                  zoom: 16.5,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c'],
                  ),
                  PolygonLayer(polygons: [
                    Polygon(
                      points: multipolygon,
                      color: Colors.green.withOpacity(0.5),
                      borderStrokeWidth: 3,
                    ),
                  ]),
                  MarkerLayer(
                    markers: markers,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showModal,
        child: Icon(Icons.menu),
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
    for (var e in geometries) {
      List<double> point = e!.split(" ").map((e) => double.parse(e)).toList();
      list.add(point);
    }
    coordinates.add(list);
    List<List<LatLng>> points = [];
    for (var p in coordinates) {
      List<LatLng> list = [];
      for (var c in p) {
        list.add(LatLng(c[1], c[0]));
      }
      points.add(list);
    }
    List<LatLng> multipoints = points[0];
    for (var point in multipoints) {
      String coord = "(${point.longitude}, ${point.latitude})";
      PrelevementModel? prelevement = await PrelevementRepository()
          .getPrelevementByPlanSondage(coord, context)
          .catchError((error) {});
      // ignore: use_build_context_synchronously
      PlanSondageModel ps = await PlanSondageRepository()
          .getPlanSondageByCoords(coord, context)
          .catchError((error) {});
      if (prelevement == null) {
        markers.add(
          Marker(
            point: point,
            builder: (context) => GestureDetector(
              child: Icon(
                Icons.location_on,
                color: Colors.grey,
              ),
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NouveauPrelevement(
                        planSondage: ps, securisation: widget.securisation),
                  ),
                );
                if (result == true) {
                  refreshPage();
                }
              },
            ),
          ),
        );
      } else {
        MaterialColor statusColor;
        if (prelevement.statut == StatutEnum.Securise) {
          statusColor = Colors.green;
        } else if (prelevement.statut == StatutEnum.A_Verifier) {
          statusColor = Colors.orange;
        } else if (prelevement.statut == StatutEnum.Non_Securise) {
          statusColor = Colors.red;
        } else {
          statusColor = Colors.orange;
        }
        markers.add(
          Marker(
            point: point,
            builder: (context) => GestureDetector(
              child: Icon(
                Icons.location_on,
                color: statusColor,
              ),
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ModifierPrelevement(
                      prelevement: prelevement,
                    ),
                  ),
                );
                if (result == true) {
                  refreshPage();
                }
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

  void _addPrelevement(BuildContext context, PlanSondageModel ps) async {
    Navigator.pop(context);
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NouveauPrelevement(
            planSondage: ps, securisation: widget.securisation),
      ),
    );
    if (result == true) {
      refreshPage();
    }
  }

  void _updatePrelevement(
      BuildContext context, PrelevementModel prelevement) async {
    Navigator.pop(context);
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ModifierPrelevement(
          prelevement: prelevement,
        ),
      ),
    );
    if (result == true) {
      refreshPage();
    }
  }

  _deletePrelevement(BuildContext context, PrelevementModel item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MyDialog(
          onPressed: () async {
            await PrelevementRepository().deletePrelevement(item.id!, context);
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
            refreshPage();
          },
        );
      },
    );
  }

  Future<List<PlanSondageModel?>> _fetchPlanSondageList() async {
    final list =
        widget.planSondage.where((element) => element != null).toList();
    return list;
  }

  _showModal() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                children: <Widget>[
                  Text(widget.parcelle!.nom!,
                      style: TextStyle(fontSize: 20, color: Colors.green)),
                  FutureBuilder<List<PlanSondageModel?>>(
                    future: _fetchPlanSondageList(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final planSondageList = snapshot.data!;
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: planSondageList.length,
                          itemBuilder: (context, index) {
                            final planSondage = planSondageList[index]!;
                            return FutureBuilder<PrelevementModel?>(
                              future: PrelevementRepository()
                                  .getPrelevementByPlanSondageId(
                                      planSondage.id!, context)
                                  .catchError((error) {}),
                              builder: (context, snapshot) {
                                Color statusColor;
                                if (snapshot.hasData && snapshot.data != null) {
                                  if (snapshot.data!.statut ==
                                      StatutEnum.Securise) {
                                    statusColor = Colors.green;
                                  } else if (snapshot.data!.statut ==
                                      StatutEnum.A_Verifier) {
                                    statusColor = Colors.orange;
                                  } else if (snapshot.data!.statut ==
                                      StatutEnum.Non_Securise) {
                                    statusColor = Colors.red;
                                  } else {
                                    statusColor = Colors.orange;
                                  }
                                } else {
                                  statusColor = Colors.grey;
                                }
                                return ListTile(
                                  title: Text(planSondage.baseRef.toString()),
                                  trailing: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: statusColor,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  leading: IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () async {
                                      if (statusColor != Colors.grey) {
                                        _deletePrelevement(
                                            context, snapshot.data!);
                                      } else {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              "Il n'y a pas encore de prélèvement"),
                                        ));
                                      }
                                    },
                                  ),
                                  onTap: () {
                                    if (statusColor == Colors.grey) {
                                      _addPrelevement(context, planSondage);
                                    } else {
                                      _updatePrelevement(
                                          context, snapshot.data!);
                                    }
                                  },
                                );
                              },
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
