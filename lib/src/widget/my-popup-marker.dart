import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/position-model.dart';
import 'package:flutter_application/src/repositories/position-repository.dart';
import 'package:flutter_application/src/screens/form_marker.dart';
import 'package:geocoder/geocoder.dart';
import 'package:latlong2/latlong.dart';

class MyPopupMarker extends StatelessWidget {
  final LatLng point;

  MyPopupMarker({required this.point});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            "${point.latitude}",
            overflow: TextOverflow.ellipsis,
            softWrap: false,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          child: Text(
            "${point.longitude}",
            overflow: TextOverflow.ellipsis,
            softWrap: false,
          ),
        ),
        TextButton(
          child: Text("Nouvelle Sécurisation"),
          onPressed: () async {
            PositionModel? p = await PositionRepository()
                .getPositionByLatAndLong(point.latitude.toString(),
                    point.longitude.toString(), context);
            if (p == null) {
              // Get Address
              var addresses = await Geocoder.local.findAddressesFromCoordinates(
                  Coordinates(point.latitude, point.longitude));
              var first = addresses.first;
              var adresse = first.addressLine;
              // Navigation
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FormMarker(point: point, adresse: adresse),
                ),
              );
            } else {
              // Navigation
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FormMarker(point: point, adresse: p.address.toString()),
                ),
              );
            }
          },
        ),
      ]),
    );
  }
}
