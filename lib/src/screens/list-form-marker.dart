import 'package:flutter/material.dart';
import 'package:flutter_application/src/repositories/form-marker-repository.dart';
import 'package:flutter_application/src/screens/detail-position.dart';

class ListFormMarker extends StatefulWidget {
  final int? id;

  const ListFormMarker({this.id, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ListFormMarkerState();
  }
}

class _ListFormMarkerState extends State<ListFormMarker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Form Marker"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder(
        future: FormMarkerRepository().getByPositionId(widget.id!, context),
        builder: (context, snapshot) {
          print(snapshot.data.toString());
          if (snapshot.data == null) {
            return Center(child: Icon(Icons.error));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('${snapshot.data![index].numero}',
                    style: TextStyle(fontSize: 17)),
                subtitle: Text(
                  '${snapshot.data![index].description}',
                  style: TextStyle(fontSize: 15),
                ),
                trailing: TextButton(
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    /*PositionRepository()
                        .deletePosition(snapshot.data![index], context);
                    setState(() {});*/
                  },
                ),
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
    );
  }
}
