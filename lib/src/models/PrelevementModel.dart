import 'package:flutter_application/src/models/MunitionReferenceEnum.dart';
import 'package:flutter_application/src/models/PlanSondageModel.dart';
import 'package:flutter_application/src/models/SecurisationModel.dart';
import 'package:flutter_application/src/models/StatutEnum.dart';

class PrelevementModel {
  int? id;
  int numero;
  MunitionReferenceEnum munitionReference;
  int cotePlateforme;
  int profondeurASecuriser;
  int coteASecuriser;
  StatutEnum? statut;
  String? remarques;

  PrelevementModel(
      {this.id,
      required this.numero,
      required this.munitionReference,
      required this.cotePlateforme,
      required this.profondeurASecuriser,
      required this.coteASecuriser,
      required this.remarques,
      required this.statut});

  @override
  String toString() {
    return 'Prevelement { id: $id, numero: $numero, munitionReference: $munitionReference, '
        'cotePlateforme: $cotePlateforme, profondeurASecuriser: $profondeurASecuriser,  '
        'coteASecuriser: $coteASecuriser, remarques: $remarques, statut: $statut}\n';
  }

  factory PrelevementModel.fromJson(Map<String, dynamic> json) {
    return PrelevementModel(
      id: json['id'] as int,
      numero: json['numero'] as int,
      munitionReference:
          MunitionReferenceEnum.fromJson(json['munitionReference']),
      statut:
          json['statut'] != null ? StatutEnum.fromJson(json['statut']) : null,
      remarques: json['remarques'] != null ? json['remarques'] as String : null,
      cotePlateforme: json['cotePlateforme'] as int,
      profondeurASecuriser: json['profondeurASecuriser'] as int,
      coteASecuriser: json['coteASecuriser'] as int,
      //planSondage: PlanSondageModel.fromJson(json['planSondage']),
      //securisation: SecurisationModel.fromJson(json['securisation']),
    );
  }

  Map<String, dynamic> toJson(PrelevementModel p) {
    return {
      'id': p.id,
      'numero': p.numero,
      'munitionReference': p.munitionReference.toJson(),
      'remarques': p.remarques,
      'statut': p.statut!.toJson(),
      'cotePlateforme': p.cotePlateforme,
      'profondeurASecuriser': p.profondeurASecuriser,
      'coteASecuriser': p.coteASecuriser,
      //'planSondage': p.planSondage,
      //'securisation': p.securisation,
    };
  }

  factory PrelevementModel.fromMap(Map<String, dynamic> map) {
    return PrelevementModel(
        id: map['id'],
        numero: map['numero'],
        munitionReference: map['munitionReference'],
        remarques: map['remarques'],
        statut: map['statut'],
        cotePlateforme: map['cotePlateforme'],
        profondeurASecuriser: map['profondeurASecuriser'],
        coteASecuriser: map['coteASecuriser']);
  }

  Map<String, dynamic> toMap() {
    return {
      'numero': numero,
      'munitionReference': munitionReference,
      'statut': statut,
      'remarques': remarques,
      'cotePlateforme': cotePlateforme,
      'profondeurASecuriser': profondeurASecuriser,
      'coteASecuriser': coteASecuriser
    };
  }
}
