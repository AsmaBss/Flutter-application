class PlanSondageModel {
  int? id;
  String? nom;
  String? fichierShp;
  String? fichierShx;
  String? fichierDbf;
  String? fichierPrj;
  String? type;
  //String? geometry;
  double? latitude;
  double? longitude;
  String? baseRef;
  int? parcelle;

  PlanSondageModel({
    this.id,
    this.nom,
    this.fichierShp,
    this.fichierShx,
    this.fichierDbf,
    this.fichierPrj,
    this.type,
    this.latitude,
    this.longitude,
    this.baseRef,
    this.parcelle,
    //this.prelevement_id
  });

  @override
  String toString() {
    return 'PlanSondage { id: $id, nom: $nom, '
        'fichierShp: $fichierShp, fichierShx: $fichierShx, '
        'fichierDbf: $fichierDbf, fichierPrj: $fichierPrj, '
        'type: $type, latitude: $latitude,longitude: $longitude, '
        'baseRef: $baseRef, parcelle: $parcelle}\n';
    // , prelevement_id: $prelevement_id
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
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      //geometry: json['geometry']['coordinates'] as String,
      baseRef: json['baseRef'] as String,
      parcelle: json['parcelle']['id'] as int,
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
      'latitude': p.latitude,
      'longitude': p.longitude,
      'baseRef': p.baseRef,
      'parcelle': p.parcelle,
    };
  }

  factory PlanSondageModel.fromMap(Map<String, dynamic> map) {
    return PlanSondageModel(id: map['id'] ?? "")
      ..nom = (map['nom'] ?? "")
      ..type = (map['type'] ?? "")
      ..latitude = (map['latitude'] ?? "")
      ..longitude = (map['longitude'] ?? "")
      ..fichierShp = (map['fichierShp'] ?? "")
      ..fichierShx = (map['fichierShx'] ?? "")
      ..fichierDbf = (map['fichierDbf'] ?? "")
      ..fichierPrj = (map['fichierPrj'] ?? "")
      ..baseRef = (map['baseRef'] ?? "")
      ..parcelle = (map['parcelle'] ?? "");
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'type': type,
      'latitude': latitude,
      'longitude': longitude,
      'fichierShp': fichierShp,
      'fichierShx': fichierShx,
      'fichierDbf': fichierDbf,
      'fichierPrj': fichierPrj,
      'baseRef': baseRef,
      'parcelle': parcelle,
    };
  }
}
