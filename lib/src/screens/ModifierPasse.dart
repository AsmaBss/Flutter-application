import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/PasseModel.dart';
import 'package:flutter_application/src/repositories/PasseRepository.dart';
import 'package:flutter_application/src/widget/NouveauPasseFormWidget.dart';

class ModifierPasse extends StatefulWidget {
  final PasseModel passe;

  const ModifierPasse({required this.passe});

  @override
  _ModifierPasseState createState() => _ModifierPasseState();
}

class _ModifierPasseState extends State<ModifierPasse> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController gradient = TextEditingController();
  TextEditingController coteSecurisee = TextEditingController();
  TextEditingController profondeurSecurisee = TextEditingController();
  TextEditingController profondeurSonde = TextEditingController();

  @override
  void initState() {
    gradient.text = widget.passe.gradientMag.toString();
    coteSecurisee.text = widget.passe.coteSecurisee.toString();
    profondeurSecurisee.text = widget.passe.profondeurSecurisee.toString();
    profondeurSonde.text = widget.passe.profondeurSonde.toString();
    super.initState();
  }

  @override
  void dispose() {
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
        title: Text("Modifier Passe"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(30.0),
        child: Column(
          children: [
            NouveauPasseFormWidget(
              formKey: _formKey,
              //munitionRef: munitionRef,
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
                      if (_formKey.currentState!.validate()) {
                        PasseRepository().updatePasse(
                            PasseModel(
                                //munitionReference: munitionRef.text,
                                profondeurSonde:
                                    int.parse(profondeurSonde.text),
                                gradientMag: int.parse(gradient.text),
                                profondeurSecurisee:
                                    int.parse(profondeurSecurisee.text),
                                coteSecurisee: int.parse(coteSecurisee.text)),
                            widget.passe.id!,
                            context);
                      }
                    },
                    child: Text("Modifier"),
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
