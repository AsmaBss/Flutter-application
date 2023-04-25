import 'dart:math';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/position-model.dart';
import 'package:flutter_application/src/repositories/position-repository.dart';
import 'package:flutter_application/src/widget/DrawerWidget.dart';
import 'package:flutter_application/src/widget/my-popup-marker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:geocoder/geocoder.dart';
import 'package:latlong2/latlong.dart';

class Maps extends StatefulWidget {
  const Maps({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  final String _apiUrl = "${dotenv.env['GEOSERVER_URL']}";
  List<Marker> allMarkers = [];

  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  late final MapController _mapController;
  final PopupController _popupLayerController = PopupController();

  @override
  void initState() {
    super.initState();
    _loadMarkers();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _mapController.dispose();
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
      body: Center(
        child: Column(
          children: [
            Flexible(
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  center: LatLng(36.806389, 10.181667),
                  zoom: 8, //5
                  onTap: (tapPosition, point) async {
                    // Get Address
                    var addresses = await Geocoder.local
                        .findAddressesFromCoordinates(
                            Coordinates(point.latitude, point.longitude));
                    var first = addresses.first;
                    var adresse =
                        "${first.locality}, ${first.adminArea}, ${first.countryName}";
                    var street = first.addressLine;
                    // Add Marker
                    allMarkers.add(
                      Marker(
                        point: point,
                        builder: (BuildContext context) => Icon(
                          Icons.location_on,
                          color: Colors.red,
                        ),
                      ),
                    );
                    // Save locally
                    // ....
                    setState(() {});
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c'],
                  ),
                  TileLayer(
                    backgroundColor: Colors.transparent,
                    wmsOptions: WMSTileLayerOptions(
                      baseUrl: '$_apiUrl/parcelles/wms?',
                      layers: ['parcelles:Group1'],
                      transparent: true,
                      format: 'image/png',
                    ),
                  ),
                  PopupMarkerLayerWidget(
                    options: PopupMarkerLayerOptions(
                      popupController: _popupLayerController,
                      markers: allMarkers,
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
                          point: marker.point,
                        ),
                        
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: MyDrawer(),
    );
  }

  _loadMarkers() async {
    List positions = await PositionRepository().getAllPositions(context);
    for (PositionModel element in positions) {
      LatLng tappedPoint = LatLng(
          double.parse(element.latitude!), double.parse(element.longitude!));
      allMarkers.add(
        Marker(
          point: tappedPoint,
          builder: (BuildContext context) => Icon(
            Icons.location_on,
            color: Colors.red,
          ),
        ),
      );
    }
    setState(() {});
  }
}
