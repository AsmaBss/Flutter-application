import 'package:flutter_application/src/models/MunitionReferenceEnum.dart';
import 'package:flutter_application/src/models/StatutEnum.dart';

class PrelevementModel {
  int? id;
  String numero;
  MunitionReferenceEnum munitionReference;
  double cotePlateforme;
  double profondeurASecuriser;
  double coteASecuriser;
  StatutEnum? statut;
  String? remarques;
  int? plan_sondage;

  PrelevementModel(
      {this.id,
      required this.numero,
      required this.munitionReference,
      required this.cotePlateforme,
      required this.profondeurASecuriser,
      required this.coteASecuriser,
      required this.remarques,
      required this.statut,
      this.plan_sondage});

  @override
  String toString() {
    return 'Prevelement { id: $id, numero: $numero, munitionReference: $munitionReference, '
        'cotePlateforme: $cotePlateforme, profondeurASecuriser: $profondeurASecuriser,  '
        'coteASecuriser: $coteASecuriser, remarques: $remarques, statut: $statut, plan_sondage: $plan_sondage}\n';
  }

  factory PrelevementModel.fromJson(Map<String, dynamic> json) {
    return PrelevementModel(
      id: json['id'] as int,
      numero: json['numero'] as String,
      munitionReference:
          MunitionReferenceEnum.fromJson(json['munitionReference']),
      statut:
          json['statut'] != null ? StatutEnum.fromJson(json['statut']) : null,
      remarques: json['remarques'] != null ? json['remarques'] as String : null,
      cotePlateforme: json['cotePlateforme'] as double,
      profondeurASecuriser: json['profondeurASecuriser'] as double,
      coteASecuriser: json['coteASecuriser'] as double,
      plan_sondage: json['planSondage']['id'] as int,
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
      'planSondage': p.plan_sondage,
    };
  }

  factory PrelevementModel.fromMap(Map<String, dynamic> map) {
    return PrelevementModel(
        id: map['id'],
        numero: map['numero'],
        munitionReference:
            MunitionReferenceEnum.fromJson(map['munitionReference']),
        remarques: map['remarques'],
        statut: StatutEnum.fromJson(map['statut']),
        cotePlateforme: map['cotePlateforme'],
        profondeurASecuriser: map['profondeurASecuriser'],
        coteASecuriser: map['coteASecuriser'],
        plan_sondage: map['planSondage']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'numero': numero,
      'munitionReference': munitionReference.toJson(),
      'statut': statut!.toJson(),
      'remarques': remarques,
      'cotePlateforme': cotePlateforme,
      'profondeurASecuriser': profondeurASecuriser,
      'coteASecuriser': coteASecuriser,
      'planSondage': plan_sondage
    };
  }
}
