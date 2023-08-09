import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application/src/api-services/SharedPreference.dart';
import 'package:flutter_application/src/models/ParcelleModel.dart';
import 'package:flutter_application/src/models/PlanSondageModel.dart';
import 'package:flutter_application/src/models/SynchronisationModel.dart';
import 'package:flutter_application/src/models/user-model.dart';
import 'package:flutter_application/src/repositories/parcelle-repository.dart';
import 'package:flutter_application/src/repositories/plan-sondage-repository.dart';
import 'package:flutter_application/src/repositories/synchronisation_repository.dart';
import 'package:flutter_application/src/screens/login.dart';
import 'package:flutter_application/src/screens/modif/maps.dart';
import 'package:flutter_application/src/sqlite/SecurisationQuery.dart';
import 'package:flutter_application/src/sqlite/SynchronisationQuery.dart';
import 'package:flutter_application/src/sqlite/images-observation.dart';
import 'package:flutter_application/src/sqlite/images-query.dart';
import 'package:flutter_application/src/sqlite/observation-query.dart';
import 'package:flutter_application/src/sqlite/parcelle-query.dart';
import 'package:flutter_application/src/sqlite/passe-query.dart';
import 'package:flutter_application/src/sqlite/plan-sondage-query.dart';
import 'package:flutter_application/src/sqlite/prelevement-query.dart';
import 'package:flutter_application/src/sqlite/sqlite-api.dart';
import 'package:flutter_application/src/sqlite/user-query.dart';

class ListParcelle extends StatefulWidget {
  final UserModel user;

  const ListParcelle({required this.user, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ListParcelleState();
  }
}

class _ListParcelleState extends State<ListParcelle> {
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
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Liste des parcelles"),
          automaticallyImplyLeading: false,
          actions: [
            PopupMenuButton(
              onSelected: (value) async {
                if (value == "logout") {
                  SharedPreference().removeJwtToken();
                  SharedPreference().removeUser();
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login(),
                    ),
                  );
                } else if (value == 'importer') {
                  SynchronisationQuery().deleteAllSynchronisations();
                  await UserQuery().insertUsers();
                  await ParcelleQuery().insertParcelles();
                  await PlanSondageQuery().insertPlanSondage();
                  await SecurisationQuery().insertSecurisations();
                  await PrelevementQuery().insertPrelevements();
                  await PasseQuery().insertPasses();
                  await ImagesQuery().insertImagesPrelevement();
                  await ObservationQuery().insertObservations();
                  await ImagesObservationQuery().insertImagesObservations();
                  setState(() {});
                } else if (value == 'exporter') {
                  /*List<SynchronisationModel>? list =
                      await SynchronisationQuery().showAllSynchronisations();*/
                  SqliteApi().getAllSynchronisation();
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    value: "logout",
                    child: Text("Déconnecter"),
                  ),
                  PopupMenuItem(
                    value: 'importer',
                    child: Text("Importer"),
                  ),
                  PopupMenuItem(
                    value: "exporter",
                    child: Text("Exporter"),
                  )
                ];
              },
            ),
          ],
        ),
        body: FutureBuilder(
          future: loadParcelles(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return Center(child: Text("Il n'y a pas encore des parcelles"));
              } else {
                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    final item = snapshot.data![index];
                    return ListTile(
                      isThreeLine: true,
                      title: Text(item.nom!, style: TextStyle(fontSize: 18)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              children: [
                                Text(
                                  'Nombre de points de sondage : ',
                                  style: TextStyle(fontSize: 15),
                                ),
                                FutureBuilder<int?>(
                                  /*future: PlanSondageRepository()
                                      .nbrByParcelle(item.id!, context),*/
                                  future: nbrPlanSondage(item.id!),
                                  builder: (context, snapshot) {
                                    return Text('${snapshot.data}');
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      onTap: () async {
                        _navigateToMapPrelevement(item);
                      },
                    );
                  },
                );
              }
            }
            return Center(child: Text("Error : ${snapshot.error.toString()}"));
          },
        ),
      ),
    );
  }

  Future<List<ParcelleModel>?> loadParcelles() async {
    Future<List<ParcelleModel>?>? list =
        ParcelleRepository().getByUser(widget.user.id!, context);
    //Future<List<ParcelleModel>?>? list = ParcelleQuery().showParcelles();
    return list;
  }

  Future<int?> nbrPlanSondage(int id) async {
    return await PlanSondageRepository().nbrByParcelle(id, context);
    //return PlanSondageQuery().nbrPlanSondageByParcelleId(id);
  }

  void _navigateToMapPrelevement(ParcelleModel item) async {
    List<PlanSondageModel>? planSondage =
        await PlanSondageRepository().getByParcelle(item.id!, context);
    /*List<PlanSondageModel>? planSondage =
        await PlanSondageQuery().showPlanSondageByParcelleId(item.id!);*/
    // ignore: use_build_context_synchronously
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
              Maps(planSondage: planSondage!, parcelle: item, leading: true),
        ));
  }
}
