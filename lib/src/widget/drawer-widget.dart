import 'package:flutter/material.dart';
import 'package:flutter_application/src/screens/ListSecurisation.dart';
import 'package:flutter_application/src/screens/nouvelle-securisation.dart';
import 'package:flutter_application/src/screens/list-observations.dart';

class MyDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyDrawerState();
  }
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.green),
            child: Text("header"),
          ),
          ListTile(
            title: Text('Liste des observations'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => ListObservations()));
            },
          ),
          ListTile(
            title: Text('Liste des sécurisations'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => ListSecurisation()));
            },
          ),
          ListTile(
            title: Text('Nouvelle Sécurisation'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => NouvelleSecurisation()));
            },
          ),
        ],
      ),
    );
  }
}
