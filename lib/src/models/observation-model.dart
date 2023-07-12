class ObservationModel {
  int? id;
  String? nom;
  String? description;
  String? latitude;
  String? longitude;

  ObservationModel({
    this.id,
    required this.nom,
    required this.description,
    this.latitude,
    this.longitude,
  });

  @override
  String toString() {
    return 'Observation { id: $id, nom: $nom, description: $description, '
        'latitude: $latitude , longitude: $longitude}\n';
  }

  factory ObservationModel.fromJson(Map<String, dynamic> json) {
    return ObservationModel(
      id: json['id'] as int,
      nom: json['nom'] as String,
      description: json['description'] as String,
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
    );
  }

  Map<String, dynamic> toJson(ObservationModel p) {
    return {
      'id': p.id,
      'nom': p.nom,
      'description': p.description,
      'latitude': p.latitude,
      'longitude': p.longitude,
    };
  }

  factory ObservationModel.fromMap(Map<String, dynamic> map) {
    return ObservationModel(
        id: map['id'],
        nom: map['nom'],
        description: map['description'],
        longitude: map['longitude'],
        latitude: map['latitude']);
  }

  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
