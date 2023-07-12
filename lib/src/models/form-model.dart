class FormModel {
  int? id;
  String? titre;
  String? description;
  String? fields;

  FormModel({this.id, this.titre, this.description, this.fields});

  @override
  String toString() {
    return 'Form { id: $id, titre: $titre, description: $description, fields: $fields}\n';
  }

  factory FormModel.fromJson(Map<String, dynamic> json) {
    return FormModel(
        id: json['id'] as int,
        titre: json['titre'] as String,
        description: json['description'] as String,
        fields: json['fields'] as String);
  }

  Map<String, dynamic> toJson(FormModel p) {
    return {
      'id': p.id,
      'titre': p.titre,
      'description': p.description,
      'fields': p.fields
    };
  }

  factory FormModel.fromMap(Map<String, dynamic> map) {
    return FormModel(titre: map['titre'] ?? "")
      ..description = (map['description'] ?? "")
      ..fields = (map['fields'] ?? "");
  }

  Map<String, dynamic> toMap() {
    return {'titre': titre, 'description': description, 'fields': fields};
  }
}
