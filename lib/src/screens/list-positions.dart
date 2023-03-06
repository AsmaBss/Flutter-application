import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/position-model.dart';
import 'package:flutter_application/src/repositories/position-repository.dart';
import 'package:flutter_application/src/screens/detail-position.dart';
import 'package:flutter_application/src/widget/my-drawer.dart';

class ListPositions extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ListPositionsState();
  }
}

class _ListPositionsState extends State<ListPositions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All positions"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        child: FutureBuilder(
          future: PositionRepository().getAllPositions(context),
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
                  title: Text('${snapshot.data![index].addresse}'),
                  subtitle: Text('${snapshot.data![index].description}'),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            DetailPosition(id: snapshot.data![index].id)));
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
