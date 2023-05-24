import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/MunitionReferenceEnum.dart';
import 'package:flutter_application/src/models/SecurisationModel.dart';
import 'package:flutter_application/src/widget/NouveauPasseFormWidget.dart';

class NouveauPasse extends StatefulWidget {
  final Function(MunitionReferenceEnum, int, int, int, int) nvPasse;
  final SecurisationModel securisation;
  final String cotePlateforme;
  final int profSonde;

  const NouveauPasse(
      {required this.nvPasse,
      required this.securisation,
      required this.cotePlateforme,
      required this.profSonde});

  @override
  _NouveauPasseState createState() => _NouveauPasseState();
}

class _NouveauPasseState extends State<NouveauPasse> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController gradient = TextEditingController(text: "0");
  TextEditingController coteSecurisee = TextEditingController(text: "0");
  TextEditingController profondeurSecurisee = TextEditingController(text: "0");
  TextEditingController profondeurSonde = TextEditingController(text: "0");
  MunitionReferenceEnum? _selectedMunitionReference;

  @override
  initState() {
    _selectedMunitionReference = widget.securisation.munitionReference;
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

  Future<void> _addNvPasse() async {
    print("profondeurSonde.text nvpasse => ${profondeurSonde.text}");
    widget.nvPasse(
        _selectedMunitionReference!,
        int.parse(gradient.text),
        int.parse(profondeurSonde.text),
        int.parse(coteSecurisee.text),
        int.parse(profondeurSecurisee.text));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Nouveau Passe + ${widget.profSonde}"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(30.0),
        child: Column(
          children: [
            NouveauPasseFormWidget(
              formKey: _formKey,
              valueMunitionRef: _selectedMunitionReference,
              itemsMunitionRef: MunitionReferenceEnum.values
                  .map((value) => DropdownMenuItem(
                        value: value,
                        child: Text(value.sentence),
                      ))
                  .toList(),
              onChangedDropdownMunitionRef: (MunitionReferenceEnum newValue) {
                setState(() {
                  _selectedMunitionReference = newValue;
                });
              },
              gradient: gradient,
              profondeurSonde: profondeurSonde,
              profondeurSecurisee: profondeurSecurisee,
              onChangedProfondeurSecurisee: (value) {
                String cotePlat = widget.cotePlateforme;
                String profSecurisee = profondeurSecurisee.text;
                if (profSecurisee.isEmpty || cotePlat.isEmpty) {
                  profondeurSonde.text = '';
                  coteSecurisee.text = '';
                  return;
                }
                int result1 = int.parse(cotePlat) - int.parse(profSecurisee);
                coteSecurisee.text = result1.toString();
                int result2 = widget.profSonde + int.parse(profSecurisee);
                profondeurSonde.text = result2.toString();
                setState(() {});
              },
              coteSecurisee: coteSecurisee,
            ),
            Image.asset("assets/Profondeur-vs-intensité - ESID.JPG"),
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
