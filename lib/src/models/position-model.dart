class PositionModel {
  int? id;
  String? addresse;
  String? description;
  String? latitude;
  String? longitude;

  PositionModel(
      {this.id,
      this.addresse,
      this.description,
      this.latitude,
      this.longitude});

  @override
  String toString() {
    return 'Position { id: $id, address: $addresse, '
        'description: $description, latitude: $latitude, '
        'longitude: $longitude}\n';
  }

  factory PositionModel.fromJson(Map<String, dynamic> json) {
    return PositionModel(
      id: json['id'] as int,
      addresse: json['addresse'] as String,
      description: json['description'] as String,
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
    );
  }

  Map<String, dynamic> toJson(PositionModel p) {
    return {
      'id': p.id,
      'addresse': p.addresse,
      'description': p.description,
      'latitude': p.latitude,
      'longitude': p.longitude,
    };
  }

  factory PositionModel.fromMap(Map<String, dynamic> map) {
    return PositionModel(addresse: map['addresse'] ?? "")
      ..description = (map['description'] ?? "")
      ..latitude = (map['latitude'] ?? "")
      ..longitude = (map['longitude'] ?? "");
  }

  Map<String, dynamic> toMap() {
    return {
      'addresse': addresse,
      'description': description,
      'latitude': latitude,
      'longitude': longitude
    };
  }
}
