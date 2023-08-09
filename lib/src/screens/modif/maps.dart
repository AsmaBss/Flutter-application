import 'dart:async';
import 'package:dart_jts/dart_jts.dart' as jts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/ParcelleModel.dart';
import 'package:flutter_application/src/models/PlanSondageModel.dart';
import 'package:flutter_application/src/models/PrelevementModel.dart';
import 'package:flutter_application/src/models/SecurisationModel.dart';
import 'package:flutter_application/src/models/StatutEnum.dart';
import 'package:flutter_application/src/models/observation-model.dart';
import 'package:flutter_application/src/screens/modifier-observation.dart';
import 'package:flutter_application/src/screens/modifier-prelevement.dart';
import 'package:flutter_application/src/screens/modifier-securisation.dart';
import 'package:flutter_application/src/screens/nouveau-prelevement.dart';
import 'package:flutter_application/src/screens/nouvelle-observation.dart';
import 'package:flutter_application/src/screens/nouvelle-securisation.dart';
import 'package:flutter_application/src/sqlite/SecurisationQuery.dart';
import 'package:flutter_application/src/sqlite/SynchronisationQuery.dart';
import 'package:flutter_application/src/sqlite/observation-query.dart';
import 'package:flutter_application/src/sqlite/prelevement-query.dart';
import 'package:flutter_application/src/widget/my-dialog.dart';
import 'package:flutter_application/src/widget/my-popup-marker.dart';
import 'package:flutter_application/src/widget/my-popup-marker2.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:latlong2/latlong.dart';

import 'package:location/location.dart';

class Maps extends StatefulWidget {
  final List<PlanSondageModel?> planSondage;
  final ParcelleModel parcelle;
  final bool leading;

  const Maps(
      {required this.planSondage,
      required this.parcelle,
      required this.leading,
      Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _MapsState();
}

class _MapsState extends State<Maps> with AutomaticKeepAliveClientMixin<Maps> {
  late final MapController _mapController;
  LatLng? center;
  List<List<LatLng>> multipolygon = [];
  List<LatLng> polygon = [];
  List<Marker> allSondageMarkers = [];
  List<Marker> allObservationMarkers = [];
  List<Marker> markers = [];
  final PopupController _popupLayerController = PopupController();
  final PopupController _popupLayerController2 = PopupController();
  Location? _locationService = Location();
  LocationData? _currentLocation;
  Marker? myPosition;
  SecurisationModel? securisation;

  bool _showMarkerNumber = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _mapController = MapController();
    _loadParcelle();
    _loadPlanSondage();
    _loadObservations();
    _loadSecurisation();
    SynchronisationQuery().showAllSynchronisations().then((value) {
      for (var element in value) {
        print(element.toMap());
      }
    });
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
      _loadSecurisation();
      _loadObservations();
      _fetchPlanSondageList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(widget.parcelle.nom!),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context, true);
              }),
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
                  minZoom: 0,
                  maxZoom: 21.5,
                  onTap: (tapPosition, point) {
                    _popupLayerController.hideAllPopups();
                    _popupLayerController2.hideAllPopups();
                    markers.clear();
                    if (myPosition != null) {
                      markers.add(myPosition!);
                    }
                    markers.add(
                      Marker(
                        rotate: false,
                        width: 40.0,
                        height: 40.0,
                        point: point,
                        builder: (ctx) => Icon(
                          Icons.location_on,
                          color: Colors.black,
                        ),
                      ),
                    );
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://mt1.google.com/vt/lyrs=s&x={x}&y={y}&z={z}',
                    subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
                    minZoom: 0,
                    maxZoom: 21.5,
                  ),
                  if (widget.parcelle.type == "MultiPolygon")
                    PolygonLayer(
                        polygons: multipolygon
                            .map((points) => Polygon(
                                points: points,
                                borderColor: Colors.black,
                                color: Colors.green.withOpacity(0.5),
                                borderStrokeWidth: 3))
                            .toList()),
                  if (widget.parcelle.type == "Polygon")
                    PolygonLayer(polygons: [
                      Polygon(
                        points: polygon,
                        borderColor: Colors.black,
                        color: Colors.green.withOpacity(0.3),
                        borderStrokeWidth: 3,
                      ),
                    ]),
                  if (myPosition != null)
                    MarkerLayer(
                      markers: [myPosition!],
                    ),
                  MarkerLayer(
                    markers: allSondageMarkers,
                  ),
                  MarkerLayer(
                    markers: allObservationMarkers,
                  ),
                  PopupMarkerLayerWidget(
                    options: PopupMarkerLayerOptions(
                        popupController: _popupLayerController,
                        markers: markers,
                        markerRotateAlignment:
                            PopupMarkerLayerOptions.rotationAlignmentFor(
                                AnchorAlign.top),
                        popupBuilder: (BuildContext context, Marker marker) {
                          _popupLayerController2.hideAllPopups();
                          return MyPopupMarker(
                            titre: "Nouvelle observation",
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NouvelleObservation(
                                      latLng: marker.point,
                                      parcelle: widget.parcelle),
                                ),
                              );
                              if (result == true) {
                                markers.clear();
                                _popupLayerController.hideAllPopups();
                                allObservationMarkers.add(
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
                                setState(() {});
                              }
                            },
                          );
                        }),
                  ),
                  PopupMarkerLayerWidget(
                    options: PopupMarkerLayerOptions(
                        popupController: _popupLayerController2,
                        markers: allObservationMarkers,
                        markerRotateAlignment:
                            PopupMarkerLayerOptions.rotationAlignmentFor(
                                AnchorAlign.top),
                        popupBuilder: (BuildContext context, Marker marker) {
                          _popupLayerController.hideAllPopups();
                          return MyPopupMarker2(
                            titre: "Modifier observation",
                            onPressed: () async {
                              /*ObservationModel? observation =
                                  await ObservationRepository().getByLatLng(
                                      marker.point.latitude.toString(),
                                      marker.point.longitude.toString(),
                                      context);*/
                              ObservationModel? observation =
                                  await ObservationQuery()
                                      .showObservationByLatAndLng(
                                marker.point.latitude.toString(),
                                marker.point.longitude.toString(),
                              );
                              // ignore: use_build_context_synchronously
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ModifierObservation(
                                    observation: observation!,
                                  ),
                                ),
                              );
                              _popupLayerController2.hideAllPopups();
                            },
                            titre2: "Supprimer observation",
                            onPressed2: () async {
                              /*ObservationModel? observation =
                                  await ObservationRepository().getByLatLng(
                                      marker.point.latitude.toString(),
                                      marker.point.longitude.toString(),
                                      context);*/
                              ObservationModel? observation =
                                  await ObservationQuery()
                                      .showObservationByLatAndLng(
                                marker.point.latitude.toString(),
                                marker.point.longitude.toString(),
                              );
                              // ignore: use_build_context_synchronously
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return MyDialog(
                                    onPressed: () async {
                                      /*await ObservationRepository()
                                          .deleteObservation(
                                              observation!.id!, context)
                                          .then((value) {
                                        _popupLayerController2.hideAllPopups();
                                        refreshPage();
                                      });*/
                                      await ObservationQuery()
                                          .deleteObservation(
                                              observation!, context)
                                          .then((value) {
                                        _popupLayerController2.hideAllPopups();
                                        refreshPage();
                                      });
                                    },
                                  );
                                },
                              );
                            },
                          );
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        childMargin: EdgeInsets.only(bottom: 5, right: 15),
        icon: Icons.menu,
        backgroundColor: Colors.green,
        closeManually: false,
        curve: Curves.easeIn, //bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
            child: Icon(CupertinoIcons.list_dash, color: Colors.green),
            label: 'Liste des points de sondage',
            labelStyle: TextStyle(fontSize: 16.0),
            onTap: _showModal,
          ),
          SpeedDialChild(
            child: Icon(CupertinoIcons.list_number, color: Colors.green),
            label: 'Afficher les numéros de sondage',
            labelStyle: TextStyle(fontSize: 16.0),
            onTap: () {
              setState(() {
                _showMarkerNumber = !_showMarkerNumber;
              });
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.my_location, color: Colors.green),
            label: 'Position actuelle',
            labelStyle: TextStyle(fontSize: 16.0),
            onTap: _getLocation,
          ),
          if (securisation == null)
            SpeedDialChild(
              child: Icon(CupertinoIcons.add, color: Colors.green),
              label: 'Ajouter une sécurisation',
              labelStyle: TextStyle(fontSize: 16.0),
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        NouvelleSecurisation(parcelle: widget.parcelle),
                  ),
                );
                if (result == true) {
                  refreshPage();
                }
              },
            ),
          if (securisation != null)
            SpeedDialChild(
              child: Icon(Icons.edit, color: Colors.green),
              label: 'Modifier une sécurisation',
              labelStyle: TextStyle(fontSize: 16.0),
              onTap: () async {
                final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => ModifierSecurisation(
                            securisation: securisation!,
                            parcelle: widget.parcelle)));
                if (result == true) {
                  refreshPage();
                }
              },
            ),
          if (securisation != null)
            SpeedDialChild(
              child: Icon(Icons.delete, color: Colors.green),
              label: 'Supprimer une sécurisation',
              labelStyle: TextStyle(fontSize: 16.0),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return MyDialog(
                      onPressed: () async {
                        /*await SecurisationRepository()
                            .deleteSecurisation(securisation!, context)
                            .then((value) => refreshPage());*/
                        SecurisationQuery()
                            .deleteSecurisation(securisation!, context)
                            .then((value) => refreshPage());
                      },
                    );
                  },
                );
              },
            ),
        ],
      ),
    );
  }

  _loadParcelle() {
    if (widget.parcelle.type == "MultiPolygon") {
      List<String> polygons = widget.parcelle.geometry!
          .replaceAll("MULTIPOLYGON (((", "")
          .replaceAll(")))", "")
          .split(")), ((");
      List<List<LatLng>> polygonPoints = [];
      for (String polygonString in polygons) {
        List<String> coordinates = polygonString.split(", ");
        List<LatLng> points = [];
        for (String coordinateString in coordinates) {
          List<String> coordinate = coordinateString.split(" ");
          double longitude = double.parse(coordinate[0]);
          double latitude = double.parse(coordinate[1]);
          points.add(LatLng(latitude, longitude));
        }
        polygonPoints.add(points);
      }
      multipolygon = polygonPoints;
      center = calculateMultipolygonCentroid(multipolygon);
    } else if (widget.parcelle.type == "Polygon") {
      List<String> polygonString = widget.parcelle.geometry!
          .replaceAll("POLYGON ((", "")
          .replaceAll("))", "")
          .split(", ");
      List<LatLng> polygonPoints = [];
      for (String coordinateString in polygonString) {
        List<String> coordinates = coordinateString.split(" ");
        double longitude = double.parse(coordinates[0]);
        double latitude = double.parse(coordinates[1]);
        LatLng latLng = LatLng(latitude, longitude);
        polygonPoints.add(latLng);
      }
      polygon = polygonPoints;
      center = calculateCentroid(polygon);
    }
  }

  LatLng calculateMultipolygonCentroid(List<List<LatLng>> polygonPoints) {
    double totalArea = 0.0;
    LatLng weightedCentroid = LatLng(0.0, 0.0);
    for (List<LatLng> polygon in polygonPoints) {
      double area = computeArea(polygon);
      LatLng centroid = calculateCentroid(polygon);
      totalArea += area;
      weightedCentroid = LatLng(
          weightedCentroid.latitude + area * centroid.latitude,
          weightedCentroid.longitude + area * centroid.longitude);
    }
    return LatLng(weightedCentroid.latitude / totalArea,
        weightedCentroid.longitude / totalArea);
  }

  double computeArea(List<LatLng> points) {
    double area = 0.0;
    for (int i = 0; i < points.length; i++) {
      double x_i = points[i].longitude, y_i = points[i].latitude;
      double x_i1 = points[(i + 1) % points.length].longitude,
          y_i1 = points[(i + 1) % points.length].latitude;
      area += x_i * y_i1 - x_i1 * y_i;
    }
    return 0.5 * area.abs();
  }

  LatLng calculateCentroid(List<LatLng> polygon) {
    double latitude = 0;
    double longitude = 0;
    int n = polygon.length;
    for (var i = 0; i < n; i++) {
      latitude += polygon[i].latitude;
      longitude += polygon[i].longitude;
    }
    return LatLng(latitude / n, longitude / n);
  }

  _loadPlanSondage() async {
    for (PlanSondageModel? ps in widget.planSondage) {
      /*PrelevementModel? prelevement =
          await PrelevementRepository().getByPlanSondageId(ps!.id!, context);*/
      PrelevementModel? prelevement =
          await PrelevementQuery().showPrelevementByPS(ps!.id!);
      if (prelevement == null) {
        allSondageMarkers.add(
          Marker(
            point: LatLng(ps.latitude!, ps.longitude!),
            rotate: false,
            width: 40,
            height: 40,
            builder: (context) => Column(children: [
              Visibility(
                visible: _showMarkerNumber,
                replacement: Container(
                  height: 16,
                ),
                child: Container(
                  color: Colors.black54,
                  height: 16,
                  child: Center(
                    child: Text(
                      "${ps.baseRef}",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                child: Icon(
                  Icons.location_on,
                  color: Colors.grey,
                ),
                onTap: () async {
                  _loadSecurisation();
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NouveauPrelevement(
                        planSondage: ps!,
                        securisation: securisation ?? null,
                      ),
                    ),
                  );
                  if (result == true) {
                    refreshPage();
                  }
                },
              ),
            ]),
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
        allSondageMarkers.add(
          Marker(
            point: LatLng(ps.latitude!, ps.longitude!),
            rotate: false,
            width: 40,
            height: 40,
            builder: (context) => Column(
              children: [
                Visibility(
                  visible: _showMarkerNumber,
                  replacement: Container(
                    height: 16,
                  ),
                  child: Container(
                    color: Colors.black54,
                    height: 16,
                    child: Center(
                      child: Text(
                        "${ps.baseRef}",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
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
              ],
            ),
          ),
        );
      }
      setState(() {});
    }
  }

  _loadObservations() async {
    allObservationMarkers.clear();
    /*List<ObservationModel>? observations = await ObservationRepository()
        .getAllObservations(widget.parcelle.id!, context);*/
    List<ObservationModel>? observations = await ObservationQuery()
        .showObservationByParcelleId(widget.parcelle.id!);
    for (var element in observations!) {
      allObservationMarkers.add(
        Marker(
          rotate: false,
          width: 30.0,
          height: 30.0,
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

  _loadSecurisation() async {
    /*securisation = await SecurisationRepository()
        .getByParcelleId(widget.parcelle.id!, context);*/
    securisation = await SecurisationQuery()
        .showSecurisationByParcelleId(widget.parcelle.id!);
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

  _showModal() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            height: 600,
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                children: <Widget>[
                  Text(widget.parcelle!.nom!,
                      style: TextStyle(fontSize: 20, color: Colors.green)),
                  Expanded(
                    child: FutureBuilder<List<PlanSondageModel?>>(
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
                                future: PrelevementQuery()
                                    .showPrelevementByPS(planSondage.id!),
                                /*future: PrelevementRepository()
                                    .getByPlanSondageId(
                                        planSondage.id!, context),*/
                                builder: (context, snapshot) {
                                  Color statusColor;
                                  if (snapshot.hasData &&
                                      snapshot.data != null) {
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
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return MyDialog(
                                                onPressed: () async {
                                                  /*await PrelevementRepository()
                                                      .deletePrelevement(
                                                          snapshot.data!,
                                                          context)
                                                      .then((value) {
                                                    refreshPage();
                                                    Navigator.pop(context);
                                                    refreshPage();
                                                  });*/
                                                  await PrelevementQuery()
                                                      .deletePrelevement(
                                                          snapshot.data!,
                                                          context)
                                                      .then((value) {
                                                    refreshPage();
                                                    Navigator.pop(context);
                                                    refreshPage();
                                                  });
                                                },
                                              );
                                            },
                                          );
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
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<List<PlanSondageModel?>> _fetchPlanSondageList() async {
    final list =
        widget.planSondage.where((element) => element != null).toList();
    return list;
  }

  void _addPrelevement(BuildContext context, PlanSondageModel ps) async {
    Navigator.pop(context);
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            NouveauPrelevement(planSondage: ps, securisation: securisation),
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
}
