import 'package:flutter/material.dart';
import 'package:flutter_application/src/widget/NouveauPasseFormWidget.dart';

class NouveauPasse extends StatefulWidget {
  final Function(String, int, int, int, int) nvPasse;

  const NouveauPasse({required this.nvPasse});

  @override
  _NouveauPasseState createState() => _NouveauPasseState();
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

  Future<void> _addNvPasse() async {
    widget.nvPasse(
        munitionRef.text,
        int.parse(profondeurSonde.text),
        int.parse(gradient.text),
        int.parse(profondeurSecurisee.text),
        int.parse(coteSecurisee.text));
    Navigator.pop(context);
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
                    onPressed: _addNvPasse,
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
