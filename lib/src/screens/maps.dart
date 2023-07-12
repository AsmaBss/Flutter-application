import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/src/widget/drawer-widget.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Maps extends StatefulWidget {
  const Maps({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  List<Marker> allMarkers = [];

  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  late final MapController _mapController;

  @override
  void initState() {
    super.initState();
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
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
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
                    onTap: (tapPosition, point) async {},
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c'],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        drawer: MyDrawer(),
      ),
    );
  }
}
