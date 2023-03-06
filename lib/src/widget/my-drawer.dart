import 'package:flutter/material.dart';
import 'package:flutter_application/src/screens/list-positions.dart';

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
            child: Text("header"),
            decoration: BoxDecoration(color: Colors.green),
          ),
          ListTile(
            title: Text('All Positions'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => ListPositions()));
            },
          ),
          ListTile(
            title: Text('list 2'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
