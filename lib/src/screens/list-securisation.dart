import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/ParcelleModel.dart';
import 'package:flutter_application/src/models/PlanSondageModel.dart';
import 'package:flutter_application/src/models/SecurisationModel.dart';
import 'package:flutter_application/src/repositories/parcelle-repository.dart';
import 'package:flutter_application/src/repositories/prelevement-repository.dart';
import 'package:flutter_application/src/repositories/securisation-repository.dart';
import 'package:flutter_application/src/repositories/plan-sondage-repository.dart';
import 'package:flutter_application/src/screens/map-prelevement.dart';
import 'package:flutter_application/src/screens/modifier-securisation.dart';
import 'package:flutter_application/src/screens/nouvelle-securisation.dart';
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
    // _loadSecurisation();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void refreshPage() {
    setState(() {
      //_loadSecurisation();
    });
  }

  Future<List<SecurisationModel>?> _loadSecurisation() {
    return SecurisationRepository().getAllSecurisations(context);
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
            .getAllSecurisations(context), //_loadSecurisation(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Center(
                  child: Text("Il n'y a pas encore des sécurisations"));
            } else {
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  final item = snapshot.data![index];
                  return ListTile(
                    isThreeLine: true,
                    title: Text(item.nom, style: TextStyle(fontSize: 17)),
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
                              FutureBuilder<int?>(
                                future: PrelevementRepository()
                                    .nbrBySecurisation(item.id!, context),
                                builder: (context, snapshot) {
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
                    },
                  );
                },
              );
            }
          }
          return Center(child: Text("Error : ${snapshot.error.toString()}"));
        },
      ),
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
                .then((value) => refreshPage());
          },
        );
      },
    );
  }

  void _updateItem(SecurisationModel item, BuildContext context) async {
    ParcelleModel parcelle =
        await ParcelleRepository().getSecurisation(item.id!, context);
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
    List<PlanSondageModel>? planSondage =
        await PlanSondageRepository().getByParcelle(parcelle!.id!, context);
    // ignore: use_build_context_synchronously
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => MapPrelevement(
                securisation: item,
                planSondage: planSondage!,
                parcelle: parcelle,
                leading: true)));
    if (result == true) {
      refreshPage();
    }
  }
}
