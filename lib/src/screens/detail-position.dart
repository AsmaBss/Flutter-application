import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application/src/repositories/ImageRepository.dart';

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
      body: FutureBuilder(
        future: ImageRepository().getFormMarkerById(widget.id!, context),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(child: Icon(Icons.error));
          }
          /*return GridView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (BuildContext context, int index) {
              print(snapshot.data![index].runtimeType);
              //return Image.asset(images[index], fit: BoxFit.cover);
              //return Image.network(images[index]);
              return Text("test");
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    2), //, mainAxisSpacing: 10, crossAxisSpacing: 10),
            //padding: const EdgeInsets.all(10),
            //shrinkWrap: true,
          );*/
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Image.memory(
                    Base64Decoder().convert(snapshot.data![index].image)),
                //Image.file(File(snapshot.data![index].image)),
                //subtitle: Text('${snapshot.data![index].image}'),
                onTap: () {},
              );
            },
          );
        },
      ),
    );
  }
}
