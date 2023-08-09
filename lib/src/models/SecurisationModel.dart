import 'package:flutter_application/src/models/MunitionReferenceEnum.dart';

class SecurisationModel {
  int? id;
  String nom;
  MunitionReferenceEnum munitionReference;
  double cotePlateforme;
  double profondeurASecuriser;
  double coteASecuriser;
  int? parcelle;

  SecurisationModel(
      {this.id,
      required this.nom,
      required this.munitionReference,
      required this.cotePlateforme,
      required this.profondeurASecuriser,
      required this.coteASecuriser,
      this.parcelle});

  @override
  String toString() {
    return 'Securisation { id: $id, nom: $nom, munitionReference: $munitionReference, '
        'cotePlateforme: $cotePlateforme, profondeurASecuriser: $profondeurASecuriser, '
        'coteASecuriser: $coteASecuriser, parcelle: $parcelle\n';
  }

  factory SecurisationModel.fromJson(Map<String, dynamic> json) {
    return SecurisationModel(
      id: json['id'] as int,
      nom: json['nom'] as String,
      munitionReference:
          MunitionReferenceEnum.fromJson(json['munitionReference']),
      cotePlateforme: json['cotePlateforme'] as double,
      profondeurASecuriser: json['profondeurASecuriser'] as double,
      coteASecuriser: json['coteASecuriser'] as double,
      parcelle: json['parcelle']['id'] as int,
    );
  }

  Map<String, dynamic> toJson(SecurisationModel p) {
    return {
      'id': p.id,
      'nom': p.nom,
      'munitionReference': munitionReference.toJson(),
      'cotePlateforme': p.cotePlateforme,
      'profondeurASecuriser': p.profondeurASecuriser,
      'coteASecuriser': p.coteASecuriser,
      'parcelle': p.parcelle,
    };
  }

  factory SecurisationModel.fromMap(Map<String, dynamic> map) {
    return SecurisationModel(
      id: map['id'],
      nom: map['nom'],
      munitionReference:
          MunitionReferenceEnum.fromJson(map['munitionReference']),
      cotePlateforme: map['cotePlateforme'],
      profondeurASecuriser: map['profondeurASecuriser'],
      coteASecuriser: map['coteASecuriser'],
      parcelle: map['parcelle'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'munitionReference': munitionReference.toJson(),
      'cotePlateforme': cotePlateforme,
      'profondeurASecuriser': profondeurASecuriser,
      'coteASecuriser': coteASecuriser,
      'parcelle': parcelle
    };
  }
}
