class FormMarkerModel {
  int? id;
  String? numero;
  String? description;
  int? positionId;

  FormMarkerModel({this.id, this.numero, this.description, this.positionId});

  @override
  String toString() {
    return 'FormMarker { id: $id, numero: $numero, '
        'description: $description, positionId: $positionId}\n';
  }

  factory FormMarkerModel.fromJson(Map<String, dynamic> json) {
    return FormMarkerModel(
        id: json['id'] as int,
        numero: json['numero'] as String,
        description: json['description'] as String,
        positionId: json['positionId'] as int);
  }

  Map<String, dynamic> toJson(FormMarkerModel fm) {
    return {
      //'id': fm.id,
      'numero': fm.numero,
      'description': fm.description,
      'positionId': fm.positionId
    };
  }

  factory FormMarkerModel.fromMap(Map<String, dynamic> map) {
    return FormMarkerModel(numero: map['numero'] ?? "")
      ..description = (map['description'] ?? "")
      ..positionId = (map['positionId'] ?? "");
  }

  Map<String, dynamic> toMap() {
    return {
      'numero': numero,
      'description': description,
      'positionId': positionId
    };
  }
}
