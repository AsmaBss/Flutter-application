class PrelevementModel {
  int? id;
  int? numero;
  String? munitionReference;
  int? cotePlateforme;
  int? profondeurASecuriser;
  int? coteASecuriser;
  int? planSondage;
  int? securisation;
  String? statut;
  String? remarques;

  PrelevementModel(
      {this.id,
      this.numero,
      this.munitionReference,
      this.cotePlateforme,
      this.profondeurASecuriser,
      this.coteASecuriser,
      this.planSondage,
      this.securisation,
      this.remarques,
      this.statut});

  @override
  String toString() {
    return 'Prevelement { id: $id, numero: $numero, munitionReference: $munitionReference, '
        'cotePlateforme: $cotePlateforme, profondeurASecuriser: $profondeurASecuriser,  '
        'coteASecuriser: $coteASecuriser, remarques: $remarques, statut: $statut, '
        'planSondage: $planSondage, securisation: $securisation}\n';
  }

  factory PrelevementModel.fromJson(Map<String, dynamic> json) {
    return PrelevementModel(
      id: json['id'] as int,
      numero: json['numero'] as int,
      munitionReference: json['munitionReference'] as String,
      statut: json['statut'] as String,
      remarques: json['remarques'] as String,
      cotePlateforme: json['cotePlateforme'] as int,
      profondeurASecuriser: json['profondeurASecuriser'] as int,
      coteASecuriser: json['coteASecuriser'] as int,
      planSondage: json['planSondage'] as int,
      securisation: json['securisation'] as int,
    );
  }

  Map<String, dynamic> toJson(PrelevementModel p) {
    return {
      'id': p.id,
      'numero': p.numero,
      'munitionReference': p.munitionReference,
      'remarques': p.remarques,
      'statut': p.statut,
      'cotePlateforme': p.cotePlateforme,
      'profondeurASecuriser': p.profondeurASecuriser,
      'coteASecuriser': p.coteASecuriser,
      'planSondage': p.planSondage,
      'securisation': p.securisation,
    };
  }

  factory PrelevementModel.fromMap(Map<String, dynamic> map) {
    return PrelevementModel(numero: map['numero'] ?? "")
      ..munitionReference = (map['munitionReference'] ?? "")
      ..remarques = (map['remarques'] ?? "")
      ..statut = (map['statut'] ?? "")
      ..cotePlateforme = (map['cotePlateforme'] ?? "")
      ..profondeurASecuriser = (map['profondeurASecuriser'] ?? "")
      ..coteASecuriser = (map['coteASecuriser'] ?? "")
      ..planSondage = (map['planSondage'] ?? "")
      ..securisation = (map['securisation'] ?? "");
  }

  Map<String, dynamic> toMap() {
    return {
      'numero': numero,
      'munitionReference': munitionReference,
      'statut': statut,
      'remarques': remarques,
      'cotePlateforme': cotePlateforme,
      'profondeurASecuriser': profondeurASecuriser,
      'coteASecuriser': coteASecuriser,
      'planSondage': planSondage,
      'securisation': securisation,
    };
  }
}
