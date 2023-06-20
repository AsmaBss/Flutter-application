import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/ParcelleModel.dart';
import 'package:flutter_application/src/models/PlanSondageModel.dart';
import 'package:flutter_application/src/models/SecurisationModel.dart';
import 'package:flutter_application/src/repositories/PrelevementRepository.dart';
import 'package:flutter_application/src/repositories/SecurisationRepository.dart';
import 'package:flutter_application/src/repositories/ParcelleRepository.dart';
import 'package:flutter_application/src/repositories/PlanSondageRepository.dart';
import 'package:flutter_application/src/screens/MapPrelevement.dart';
import 'package:flutter_application/src/screens/modifier-securisation.dart';
import 'package:flutter_application/src/screens/nouvelle-securisation.dart';
import 'package:flutter_application/src/widget/drawer-widget.dart';
import 'package:flutter_application/src/widget/my-dialog.dart';

class ListSecurisation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ListSecurisationState();
  }
}

class _ListSecurisationState extends State<ListSecurisation> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void refreshPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Liste des sécurisations"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: SecurisationRepository()
            .getAllSecurisations(context)
            .catchError((error) {}),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text("Il n'y a pas encore des sécurisations"));
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                final item = snapshot.data![index];
                return ListTile(
                  isThreeLine: true,
                  title: Text('${item.nom}', style: TextStyle(fontSize: 17)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            Text(
                              'Nombre prélèvements :  ',
                              style: TextStyle(fontSize: 15),
                            ),
                            FutureBuilder<int>(
                              future: PrelevementRepository()
                                  .nbrBySecurisation(item.id!, context),
                              builder: (BuildContext context,
                                  AsyncSnapshot<int> snapshot) {
                                return Text('${snapshot.data}');
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            Text(
                              'Côte plateforme :  ',
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              '${item.cotePlateforme}',
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            Text(
                              'Plateforme à sécuriser :  ',
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              '${item.profondeurASecuriser}',
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            Text(
                              'Côte à sécuriser :  ',
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              '${item.coteASecuriser}',
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  trailing: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    direction: Axis.vertical,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          _updateItem(item, context);
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          _deleteItem(context, item);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    _navigateToMapPrelevement(item);
                    //refreshPage();
                  },
                );
              },
            );
          }
        },
      ),
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => NouvelleSecurisation()));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  _deleteItem(BuildContext context, SecurisationModel item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MyDialog(
          onPressed: () async {
            await SecurisationRepository()
                .deleteSecurisation(item.id!, context)
                .then((value) => refreshPage())
                .catchError(
                    (error) => print('Failed to delete object. Error: $error'));
          },
        );
      },
    );
  }

  void _updateItem(SecurisationModel item, BuildContext context) async {
    ParcelleModel parcelle = await ParcelleRepository()
        .getSecurisation(item.id!, context)
        .catchError((error) {});
    // ignore: use_build_context_synchronously
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ModifierSecurisation(
                  securisation: item,
                  parcelle: parcelle,
                )));
    if (result == true) {
      setState(() {});
    }
  }

  void _navigateToMapPrelevement(SecurisationModel item) async {
    ParcelleModel parcelle =
        await ParcelleRepository().getSecurisation(item.id!, context);
    List<PlanSondageModel> planSondage =
        await PlanSondageRepository().getPlanSondageByParcelle(parcelle.id!);
    // ignore: use_build_context_synchronously
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => MapPrelevement(
                  securisation: item,
                  parcelle: parcelle,
                  planSondage: planSondage,
                )));
    if (result == true) {
      refreshPage();
    }
  }
}
