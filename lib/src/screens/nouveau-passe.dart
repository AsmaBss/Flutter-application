import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/MunitionReferenceEnum.dart';
import 'package:flutter_application/src/widget/nouveau-passe-form-widget.dart';

class NouveauPasse extends StatefulWidget {
  final Function(MunitionReferenceEnum, int, int, int, int) nvPasse;
  final String cotePlateforme;
  final MunitionReferenceEnum munitionRef;
  final int profSonde;
  final int profSec;
  final int count;
  final bool first;

  const NouveauPasse(
      {required this.nvPasse,
      required this.cotePlateforme,
      required this.munitionRef,
      required this.profSonde,
      required this.profSec,
      required this.count,
      required this.first,
      Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _NouveauPasseState();
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
    _selectedMunitionReference = widget.munitionRef;
    if (widget.first == true) {
      profondeurSonde.text = "0";
    } else {
      int result1 = widget.profSonde + widget.profSec;
      profondeurSonde.text = result1.toString();
    }
    int result2 = int.parse(widget.cotePlateforme) - widget.count;
    coteSecurisee.text = result2.toString();
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
              onChangedDropdownMunitionRef: (newValue) {
                setState(() {
                  _selectedMunitionReference = newValue;
                });
              },
              gradient: gradient,
              profondeurSonde: profondeurSonde,
              profondeurSecurisee: profondeurSecurisee,
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

/*onChangedProfondeurSecurisee: (value) {
                /*String cotePlat = widget.cotePlateforme;
                String profSecurisee = profondeurSecurisee.text;
                if (profSecurisee.isEmpty || cotePlat.isEmpty) {
                  coteSecurisee.text = '';
                  return;
                }
                if (widget.count == 0) {
                  coteSecurisee.text = cotePlat;
                } else {
                  int result1 = int.parse(cotePlat) - widget.count;
                  coteSecurisee.text = result1.toString();
                }
                setState(() {});*/
              },*/
