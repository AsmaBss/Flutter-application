import 'package:flutter/material.dart';

class MyAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final List<Widget> actions;

  MyAlertDialog(
      {required this.title, required this.content, this.actions = const [], required Null Function() onPressed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      content: Text(
        content,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      actions: actions,
    );
  }
}

/*  _test(PositionModel positionModel) {
    late Future<List> futureGridView;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      futureGridView = PositionDetailsQuery().showPositionDetailsByPositionId(
          int.parse(positionModel.id.toString()));
    });

    print("length list => ${futureGridView.toString()}");
    print("_test");
    //(context as Element).markNeedsBuild();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MyFormMarker(
          title: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 5, top: 20),
                    child: Text(
                      position.addresse.toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      softWrap: false,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      positionModel.description.toString(),
                      maxLines: 2,
                      overflow: TextOverflow.visible,
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment(1.05, -0.35),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 30.0,
                    height: 30.0,
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          color: Colors.black,
                          offset: Offset(0, 1),
                          blurRadius: 2),
                    ], shape: BoxShape.circle, color: Colors.white),
                    child: Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
          content: Stack(
            alignment: Alignment.center,
            //clipBehavior: Clip.antiAlias,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyForm(
                    formKey: _formKey,
                    numero: numero,
                    description: descr,
                    textButton: TextButton.icon(
                      onPressed: () => _launchCamera(positionModel.id!),
                      icon: Icon(Icons.camera_alt),
                      label: Text("Take picture"),
                    ),
                  ),
                  SizedBox(
                    height: 300.0,
                    width: double.maxFinite,
                    //color: Colors.amberAccent,
                    child: FutureBuilder(
                      future: futureGridView,
                      builder: (context, snapshot) {
                        print("length => ${snapshot.data?.length}");
                        if (snapshot.data == null) {
                          return Center(child: Text("There is no data"));
                        }
                        print("all data1 => ${snapshot.data?.toString()}");
                        return MyGridImages(
                          itemCount: snapshot.data?.length,
                          itemBuilder: (BuildContext context, int index) {
                            //(context as Element).markNeedsBuild();
                            print("length => ${snapshot.data?.length}");
                            print("grid view");
                            print("all data2 => ${snapshot.data?.toString()}");
                            final item = snapshot.data![index];
                            return GestureDetector(
                              child: Image.file(File(item[1])),
                              onTap: () {
                                _deleteImage(context, item[0]);
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              child: Text("Submit"),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  print("numero ==> $numero");
                  print("descr ==> $descr");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
    setState(() {});
  }
  */
