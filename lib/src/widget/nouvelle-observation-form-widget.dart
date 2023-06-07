import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/ParcelleModel.dart';

class NouvelleObservationFormWidget extends StatelessWidget {
  final Key? formKey;
  final TextEditingController? nom, description;
  final ParcelleModel? valueParcelle;
  final List<DropdownMenuItem<ParcelleModel>>? itemsParcelle;
  final void Function(ParcelleModel?)? onChangedDropdownParcelle;
  final Widget? imageGrid;
  final void Function()? onPressedCam;

  NouvelleObservationFormWidget({
    this.formKey,
    this.nom,
    this.description,
    this.valueParcelle,
    this.itemsParcelle,
    this.onChangedDropdownParcelle,
    this.imageGrid,
    this.onPressedCam,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 15.0),
            child: TextFormField(
              controller: nom,
              decoration: InputDecoration(
                labelText: "Nom de l'observation",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.green),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez renseigner ce champ';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 15.0),
            child: TextFormField(
              controller: description,
              keyboardType: TextInputType.multiline,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Description',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.green),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Images",
                  style: TextStyle(color: Colors.grey[700], fontSize: 16),
                ),
                IconButton(
                  color: Colors.green,
                  onPressed: onPressedCam,
                  icon: Icon(Icons.camera_alt, size: 24),
                ),
              ],
            ),
          ),
          Container(
            height: 300,
            padding: EdgeInsets.only(bottom: 15.0),
            child: imageGrid,
          ),
        ],
      ),
    );
  }
}
