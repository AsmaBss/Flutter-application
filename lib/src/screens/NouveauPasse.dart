import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/MunitionReferenceEnum.dart';
import 'package:flutter_application/src/models/SecurisationModel.dart';
import 'package:flutter_application/src/widget/NouveauPasseFormWidget.dart';

class NouveauPasse extends StatefulWidget {
  final Function(MunitionReferenceEnum, int, int, int, int) nvPasse;
  final SecurisationModel securisation;

  const NouveauPasse({required this.nvPasse, required this.securisation});

  @override
  _NouveauPasseState createState() => _NouveauPasseState();
}

class _NouveauPasseState extends State<NouveauPasse> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController gradient = TextEditingController();
  TextEditingController coteSecurisee = TextEditingController();
  TextEditingController profondeurSecurisee = TextEditingController();
  TextEditingController profondeurSonde = TextEditingController();
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
    widget.nvPasse(
        _selectedMunitionReference!,
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
              coteSecurisee: coteSecurisee,
              profondeurSecurisee: profondeurSecurisee,
              profondeurSonde: profondeurSonde,
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
