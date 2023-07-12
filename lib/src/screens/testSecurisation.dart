import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/SecurisationModel.dart';
import 'package:flutter_application/src/repositories/securisation-repository.dart';

class TestSecurisation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TestSecurisationState();
  }
}

class _TestSecurisationState extends State<TestSecurisation> {
  @override
  void initState() {
    _fetchSecurisationList();
    super.initState();
  }

  Future<List<SecurisationModel>?> _fetchSecurisationList() async {
    return await SecurisationRepository().getAllSecurisations(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Liste des sécurisations"),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder(
        future: SecurisationRepository()
            .getAllSecurisations(context), //_fetchSecurisationList(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(
                    child: (Text(
                        "${snapshot.error.toString()} --- ${snapshot.stackTrace.toString()}")));
              } else if (snapshot.hasData) {
                return Center(child: (Text("all data ${snapshot.data}")));
              } else {
                return Center(
                    child: Text("Il n'y a pas encore des sécurisations"));
              }
            default:
              return Text("error");
          }
        },
      ),
    );
  }
}
