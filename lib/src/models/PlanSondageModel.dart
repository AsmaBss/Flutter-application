class PlanSondageModel {
  int? id;
  String? nom;
  String? fichierShp;
  String? fichierShx;
  String? fichierDbf;
  String? fichierPrj;
  String? type;
  String? geometry;
  int? baseRef;
  int? parcelle;

  PlanSondageModel(
      {this.id,
      this.nom,
      this.fichierShp,
      this.fichierShx,
      this.fichierDbf,
      this.fichierPrj,
      this.type,
      this.geometry,
      this.baseRef,
      this.parcelle});

  @override
  String toString() {
    return 'PlanSondage { id: $id, nom: $nom, '
        'fichierShp: $fichierShp, fichierShx: $fichierShx, '
        'fichierDbf: $fichierDbf, fichierPrj: $fichierPrj, '
        'type: $type, geometry: $geometry, '
        'baseRef: $baseRef, parcelle: $parcelle}\n';
  }

  factory PlanSondageModel.fromJson(Map<String, dynamic> json) {
    return PlanSondageModel(
      id: json['id'] as int,
      nom: json['nom'] as String,
      fichierShp: json['fichierShp'] as String,
      fichierShx: json['fichierShx'] as String,
      fichierDbf: json['fichierDbf'] as String,
      fichierPrj: json['fichierPrj'] as String,
      type: json['type'] as String,
      geometry: json['geometry']['coordinates'] as String,
      baseRef: json['baseRef'] as int,
      parcelle: json['parcelle'] as int,
    );
  }

  Map<String, dynamic> toJson(PlanSondageModel p) {
    return {
      'id': p.id,
      'nom': p.nom,
      'fichierShp': p.fichierShp,
      'fichierShx': p.fichierShx,
      'fichierDbf': p.fichierDbf,
      'fichierPrj': p.fichierPrj,
      'type': p.type,
      'geometry': p.geometry,
      'baseRef': p.baseRef,
      'parcelle': p.parcelle,
    };
  }

  factory PlanSondageModel.fromMap(Map<String, dynamic> map) {
    return PlanSondageModel(nom: map['nom'] ?? "")
      ..fichierShp = (map['fichierShp'] ?? "")
      ..fichierShx = (map['fichierShx'] ?? "")
      ..fichierDbf = (map['fichierDbf'] ?? "")
      ..fichierPrj = (map['fichierPrj'] ?? "")
      ..type = (map['type'] ?? "")
      ..geometry = (map['geometry'] ?? "")
      ..baseRef = (map['baseRef'] ?? "")
      ..parcelle = (map['parcelle'] ?? "");
  }

  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'fichierShp': fichierShp,
      'fichierShx': fichierShx,
      'fichierDbf': fichierDbf,
      'fichierPrj': fichierPrj,
      'type': type,
      'geometry': geometry,
      'baseRef': baseRef,
      'parcelle': parcelle
    };
  }
}
