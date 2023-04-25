class PositionModel {
  int? id;
  String? address;
  String? description;
  String? latitude;
  String? longitude;

  PositionModel(
      {this.id, this.address, this.description, this.latitude, this.longitude});

  @override
  String toString() {
    return 'Position { id: $id, address: $address, '
        'description: $description, latitude: $latitude, '
        'longitude: $longitude}\n';
  }

  factory PositionModel.fromJson(Map<String, dynamic> json) {
    return PositionModel(
      id: json['id'] as int,
      address: json['address'] as String,
      description: json['description'] as String,
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
    );
  }

  Map<String, dynamic> toJson(PositionModel p) {
    return {
      'id': p.id,
      'address': p.address,
      'description': p.description,
      'latitude': p.latitude,
      'longitude': p.longitude,
    };
  }

  factory PositionModel.fromMap(Map<String, dynamic> map) {
    return PositionModel(address: map['address'] ?? "")
      ..description = (map['description'] ?? "")
      ..latitude = (map['latitude'] ?? "")
      ..longitude = (map['longitude'] ?? "");
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'description': description,
      'latitude': latitude,
      'longitude': longitude
    };
  }
}
