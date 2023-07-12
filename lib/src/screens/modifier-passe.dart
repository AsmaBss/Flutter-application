import 'package:flutter/material.dart';
import 'package:flutter_application/src/classes/passes_temp.dart';
import 'package:flutter_application/src/models/MunitionReferenceEnum.dart';
import 'package:flutter_application/src/widget/nouveau-passe-form-widget.dart';
import 'package:photo_view/photo_view.dart';

class ModifierPasse extends StatefulWidget {
  final PassesTemp passe;
  final int index;
  final Function(int, MunitionReferenceEnum, int, int, int, int) updatePasse;

  const ModifierPasse(
      {required this.passe,
      required this.index,
      required this.updatePasse,
      Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ModifierPasseState();
}

class _ModifierPasseState extends State<ModifierPasse> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController gradient = TextEditingController();
  TextEditingController coteSecurisee = TextEditingController();
  TextEditingController profondeurSecurisee = TextEditingController();
  TextEditingController profondeurSonde = TextEditingController();
  late MunitionReferenceEnum _selectedMunitionReference;

  @override
  void initState() {
    _selectedMunitionReference = widget.passe.munitionReference;
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

  Future<void> _updatePasse() async {
    widget.updatePasse(
        widget.index,
        _selectedMunitionReference,
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
        title: Text(
            "Modifier Passe \nProfondeur sonde : ${widget.passe.profondeurSonde}"),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ],
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
                  _selectedMunitionReference = newValue!;
                });
              },
              gradient: gradient,
              profondeurSonde: profondeurSonde,
              coteSecurisee: coteSecurisee,
              profondeurSecurisee: profondeurSecurisee,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 260.0,
              child: PhotoView(
                backgroundDecoration: BoxDecoration(color: Colors.white),
                imageProvider:
                    AssetImage("assets/Profondeur-vs-intensité - ESID.JPG"),
              ),
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
                        _updatePasse();
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
