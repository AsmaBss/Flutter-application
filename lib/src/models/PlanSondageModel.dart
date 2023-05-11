class PlanSondageModel {
  int? id;
  String? file;
  String? type;
  String? geometry;
  int? baseRef;
  int? parcelle;

  PlanSondageModel(
      {this.id,
      this.file,
      this.type,
      this.geometry,
      this.baseRef,
      this.parcelle});

  @override
  String toString() {
    return 'PlanSondage { id: $id, file: $file, '
        'type: $type, geometry: $geometry, '
        'baseRef: $baseRef, parcelle: $parcelle}\n';
  }

  factory PlanSondageModel.fromJson(Map<String, dynamic> json) {
    return PlanSondageModel(
      id: json['id'] as int,
      file: json['file'] as String,
      type: json['type'] as String,
      geometry: json['geometry']['coordinates'] as String,
      baseRef: json['baseRef'] as int,
      parcelle: json['parcelle'] as int,
    );
  }

  Map<String, dynamic> toJson(PlanSondageModel p) {
    return {
      'id': p.id,
      'file': p.file,
      'type': p.type,
      'geometry': p.geometry,
      'baseRef': p.baseRef,
      'parcelle': p.parcelle,
    };
  }

  factory PlanSondageModel.fromMap(Map<String, dynamic> map) {
    return PlanSondageModel(file: map['file'] ?? "")
      ..type = (map['type'] ?? "")
      ..geometry = (map['geometry'] ?? "")
      ..baseRef = (map['baseRef'] ?? "")
      ..parcelle = (map['parcelle'] ?? "");
  }

  Map<String, dynamic> toMap() {
    return {
      'file': file,
      'type': type,
      'geometry': geometry,
      'baseRef': baseRef,
      'parcelle': parcelle
    };
  }
}
