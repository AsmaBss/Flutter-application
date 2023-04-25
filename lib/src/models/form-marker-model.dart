class FormMarkerModel {
  int? id;
  String? numero;
  String? description;
  int? position_id;

  FormMarkerModel({this.id, this.numero, this.description, this.position_id});

  @override
  String toString() {
    return 'FormMarker { id: $id, numero: $numero, '
        'description: $description, position_id: $position_id}\n';
  }

  factory FormMarkerModel.fromJson(Map<String, dynamic> json) {
    return FormMarkerModel(
        id: json['id'] as int,
        numero: json['numero'] as String,
        description: json['description'] as String,
        position_id: json['position_id'] as int);
  }

  Map<String, dynamic> toJson(FormMarkerModel fm) {
    return {
      //'id': fm.id,
      'numero': fm.numero,
      'description': fm.description,
      'position_id': fm.position_id
    };
  }

  factory FormMarkerModel.fromMap(Map<String, dynamic> map) {
    return FormMarkerModel(numero: map['numero'] ?? "")
      ..description = (map['description'] ?? "")
      ..position_id = (map['position_id'] ?? "");
  }

  Map<String, dynamic> toMap() {
    return {
      'numero': numero,
      'description': description,
      'position_id': position_id
    };
  }
}
