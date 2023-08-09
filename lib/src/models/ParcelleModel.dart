class ParcelleModel {
  int? id;
  String? nom;
  String? fichierShp;
  String? fichierShx;
  String? fichierDbf;
  String? fichierPrj;
  String? type;
  String? geometry;

  ParcelleModel(
      {this.id,
      this.nom,
      this.fichierShp,
      this.fichierShx,
      this.fichierDbf,
      this.fichierPrj,
      this.type,
      this.geometry});

  @override
  String toString() {
    return 'Parcelle { id: $id, nom: $nom, '
        'fichierShp: $fichierShp, fichierShx: $fichierShx, '
        'fichierDbf: $fichierDbf, fichierPrj: $fichierPrj, '
        'type: $type, geometry: $geometry}\n';
  }

  factory ParcelleModel.fromJson(Map<String, dynamic> json) {
    return ParcelleModel(
      id: json['id'] as int,
      nom: json['nom'] as String,
      fichierShp: json['fichierShp'] as String,
      fichierShx: json['fichierShx'] as String,
      fichierDbf: json['fichierDbf'] as String,
      fichierPrj: json['fichierPrj'] as String,
      type: json['type'] as String,
      geometry: json['geometry']['coordinates'] as String,
    );
  }

  Map<String, dynamic> toJson(ParcelleModel p) {
    return {
      'id': p.id,
      'nom': p.nom,
      'fichierShp': p.fichierShp,
      'fichierShx': p.fichierShx,
      'fichierDbf': p.fichierDbf,
      'fichierPrj': p.fichierPrj,
      'type': p.type,
      'geometry': p.geometry,
    };
  }

  factory ParcelleModel.fromMap(Map<String, dynamic> map) {
    return ParcelleModel(id: map['id'] ?? "")
      ..nom = (map['nom'] ?? "")
      ..type = (map['type'] ?? "")
      ..geometry = (map['geometry'] ?? "")
      ..fichierShp = (map['fichierShp'] ?? "")
      ..fichierShx = (map['fichierShx'] ?? "")
      ..fichierDbf = (map['fichierDbf'] ?? "")
      ..fichierPrj = (map['fichierPrj'] ?? "");
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'type': type,
      'geometry': geometry,
      'fichierShp': fichierShp,
      'fichierShx': fichierShx,
      'fichierDbf': fichierDbf,
      'fichierPrj': fichierPrj,
    };
  }
}
