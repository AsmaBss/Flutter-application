import 'package:flutter/material.dart';
import 'package:flutter_application/src/widget/NouveauPasseFormWidget.dart';

class NouveauPasse extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NouveauPasseState();
}

class _NouveauPasseState extends State<NouveauPasse> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nom = TextEditingController();
  TextEditingController munitionRef = TextEditingController();
  TextEditingController gradient = TextEditingController();
  TextEditingController coteSecurisee = TextEditingController();
  TextEditingController profondeurSecurisee = TextEditingController();
  TextEditingController profondeurSonde = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Nouveau Passe"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(30.0),
        child: Expanded(
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
                      onPressed: () {},
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
          ),
        ), //
      ),
    );
  }
}
