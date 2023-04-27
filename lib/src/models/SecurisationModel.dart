class SecurisationModel {
  int? id;
  String? nom;
  String? munitionReference;
  int? cotePlateforme;
  int? profondeurASecuriser;
  int? coteASecuriser;
  int? parcelle;

  SecurisationModel(
      {this.id,
      this.nom,
      this.munitionReference,
      this.cotePlateforme,
      this.profondeurASecuriser,
      this.coteASecuriser,
      this.parcelle});

  @override
  String toString() {
    return 'Securisation { id: $id, nom: $nom, munitionReference: $munitionReference, '
        'cotePlateforme: $cotePlateforme, profondeurASecuriser: $profondeurASecuriser, coteASecuriser: $coteASecuriser, parcelle: $parcelle}\n';
  }

  factory SecurisationModel.fromJson(Map<String, dynamic> json) {
    return SecurisationModel(
      id: json['id'] as int,
      nom: json['nom'] as String,
      munitionReference: json['munitionReference'] as String,
      cotePlateforme: json['cotePlateforme'] as int,
      profondeurASecuriser: json['profondeurASecuriser'] as int,
      coteASecuriser: json['coteASecuriser'] as int,
      parcelle: json['parcelle'] as int,
    );
  }

  Map<String, dynamic> toJson(SecurisationModel p) {
    return {
      'id': p.id,
      'nom': p.nom,
      'munitionReference': p.munitionReference,
      'cotePlateforme': p.cotePlateforme,
      'profondeurASecuriser': p.profondeurASecuriser,
      'coteASecuriser': p.coteASecuriser,
      'parcelle': p.parcelle,
    };
  }

  factory SecurisationModel.fromMap(Map<String, dynamic> map) {
    return SecurisationModel(nom: map['nom'] ?? "")
      ..munitionReference = (map['munitionReference'] ?? "")
      ..cotePlateforme = (map['cotePlateforme'] ?? "")
      ..profondeurASecuriser = (map['profondeurASecuriser'] ?? "")
      ..coteASecuriser = (map['coteASecuriser'] ?? "")
      ..parcelle = (map['parcelle'] ?? "");
  }

  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'munitionReference': munitionReference,
      'cotePlateforme': cotePlateforme,
      'profondeurASecuriser': profondeurASecuriser,
      'coteASecuriser': coteASecuriser,
      'parcelle': parcelle,
    };
  }
}
