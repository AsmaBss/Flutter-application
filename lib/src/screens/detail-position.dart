import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application/src/repositories/position-details-repository.dart';

class DetailPosition extends StatefulWidget {
  final int? id;

  const DetailPosition({this.id, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DetailPositionState();
  }
}

class _DetailPositionState extends State<DetailPosition> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail position"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        child: FutureBuilder(
          future: PositionDetailsRepository()
              .getPositionDetailsByPositionId(context, widget.id!),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(child: Icon(Icons.error)),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Image.file(File(snapshot.data![index].image)),
                  subtitle: Text('${snapshot.data![index].image}'),
                  onTap: () {},
                );
              },
            );
          },
        ),
      ),
    );
  }
}
