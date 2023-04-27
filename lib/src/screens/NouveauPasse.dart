import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/PasseModel.dart';
import 'package:flutter_application/src/widget/NouveauPasseFormWidget.dart';

import '../database/passe-query.dart';

class NouveauPasse extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NouveauPasseState();
}

class _NouveauPasseState extends State<NouveauPasse> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController munitionRef = TextEditingController();
  TextEditingController gradient = TextEditingController();
  TextEditingController coteSecurisee = TextEditingController();
  TextEditingController profondeurSecurisee = TextEditingController();
  TextEditingController profondeurSonde = TextEditingController();

  @override
  void dispose() {
    munitionRef.dispose();
    gradient.dispose();
    coteSecurisee.dispose();
    profondeurSecurisee.dispose();
    profondeurSonde.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Nouveau Passe"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(30.0),
        child: Column(
          children: [
            NouveauPasseFormWidget(
              formKey: _formKey,
              munitionRef: munitionRef,
              gradient: gradient,
              coteSecurisee: coteSecurisee,
              profondeurSecurisee: profondeurSecurisee,
              profondeurSonde: profondeurSonde,
            ),
            Padding(
              padding: EdgeInsets.all(40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      print("*********** save Passe ***********");
                      PasseQuery().addPasse(PasseModel(
                          munitionReference: munitionRef.text,
                          profondeurSonde: int.parse(profondeurSonde.text),
                          gradientMag: int.parse(gradient.text),
                          coteSecurisee: int.parse(coteSecurisee.text),
                          profondeurSecurisee:
                              int.parse(profondeurSecurisee.text),
                          prelevement: null));
                      print("*********** all Passes ***********");
                      PasseQuery().showPasses().then(
                            (value) => {
                              if (value.isNotEmpty)
                                {print("item ==> $value\n")}
                              else
                                {print("table empty")}
                            },
                          );
                      Navigator.pop(context);
                    },
                    child: Text("Enregistrer"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Annuler"),
                  ),
                ],
              ),
            ),
          ],
        ), //
      ),
    );
  }
}
