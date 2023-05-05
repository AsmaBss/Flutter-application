import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/ParcelleModel.dart';
import 'package:flutter_application/src/models/PlanSondageModel.dart';
import 'package:flutter_application/src/repositories/PrelevementRepository.dart';
import 'package:flutter_application/src/repositories/SecurisationRepository.dart';
import 'package:flutter_application/src/repositories/parcelle-repository.dart';
import 'package:flutter_application/src/repositories/plan-sondage-repository.dart';
import 'package:flutter_application/src/screens/MapPrelevement.dart';
import 'package:flutter_application/src/widget/MyDialog.dart';

class ListSecurisation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ListSecurisationState();
  }
}

class _ListSecurisationState extends State<ListSecurisation> {
  bool _isShown = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Liste  des sécurisations"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        child: FutureBuilder(
          future: SecurisationRepository().getAllSecurisations(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(
                  child: Text("Il n'y a pas encore des Sécurisations"));
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
                                'Nombre prélèvement :  ',
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
                                'Plateforme à sécuriser:  ',
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
                    trailing: SizedBox(
                      width: 50,
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.end,
                        direction: Axis.horizontal,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              _deleteSecurisation(item.id!, context);
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Colors.red,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    onTap: () async {
                      ParcelleModel parcelle = await ParcelleRepository()
                          .getSecurisation(item.id!, context);
                      List<PlanSondageModel> planSondage =
                          await PlanSondageRepository()
                              .getPlanSondageByParcelle(parcelle.id!, context);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => MapPrelevement(
                                securisation: item,
                                parcelle: parcelle,
                                planSondage: planSondage,
                                leading: true,
                              )));
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Future<Text> count(int id, BuildContext context) async {
    int count = await PrelevementRepository().nbrBySecurisation(id, context);
    print(count);
    return Text("test");
  }

  Future<void> _deleteSecurisation(int id, BuildContext buildContext) async {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return MyDialog(
          onPressed: () {
            setState(() {
              _isShown = false;
              SecurisationRepository().deleteSecurisation(id, context);
            });
          },
        );
      },
    );
  }

}
