import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/PlanSondageModel.dart';

class ListPrelevementWidget extends StatelessWidget {
  final future;
  final int? itemCount;
  final itemBuilder;
  ListPrelevementWidget({
    required this.future,
    required this.itemCount,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 80,
              child: DrawerHeader(
                  margin: EdgeInsets.all(10),
                  child: Text("Liste des plan de sondage")),
            ),
            FutureBuilder<List<PlanSondageModel?>>(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final planSondageList = snapshot.data!;
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: planSondageList.length,
                    itemBuilder: (context, index) {
                      final planSondage = planSondageList[index]!;
                      Color statusColor;
                      if (planSondage.id == 1) {
                        statusColor = Colors.green;
                      } else {
                        statusColor = Colors.red;
                      }
                      return ListTile(
                        title: Text(planSondage.file!),
                        subtitle: Text("numero"),
                        trailing: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: statusColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onTap: () {
                          if (statusColor == Colors.green) {
                            //modifier;
                          } else {
                            //nouveau;
                          }
                        },
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                // By default, show a loading spinner.
                return Center(child: CircularProgressIndicator());
              },
            ),
            /*FutureBuilder<List<PlanSondageModel?>>(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final planSondageList = snapshot.data!;
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: planSondageList.length,
                    itemBuilder: (context, index) {
                      final planSondage = planSondageList[index]!;
                      Color statusColor;
                      if (planSondage.id == 1) {
                        statusColor = Colors.green;
                      } else {
                        statusColor = Colors.red;
                      }
                      return ListTile(
                        title: Text(planSondage.file!),
                        subtitle: Text("numero"),
                        trailing: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: statusColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onTap: () {
                          if (statusColor == Colors.green) {
                            //modifier;
                          } else {
                            //nouveau;
                          }
                        },
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                // By default, show a loading spinner.
                return Center(child: CircularProgressIndicator());
              },
            ),
          */
          ],
        ),
      ),
    );
  }
}
