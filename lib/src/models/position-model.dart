import 'dart:convert';

class PositionModel {
  int? id;
  String? addresse;
  String? description;
  String? latitude;
  String? longitude;
  String? image;

  PositionModel(
      {this.addresse,
      this.description,
      this.latitude,
      this.longitude,
      this.image});

  @override
  String toString() {
    return 'Position { id: $id, address: $addresse, '
        'description: $description, latitude: $latitude, '
        'longitude: $longitude, image: $image}';
  }

  factory PositionModel.fromJson(Map<String, dynamic> json) {
    return PositionModel(
      addresse: json['addresse'] as String,
      description: json['description'] as String,
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
      image: json['image'] as String,
    );
  }

  Map<String, dynamic> toJson(PositionModel p) {
    return {
      'addresse': p.addresse,
      'description': p.description,
      'latitude': p.latitude,
      'longitude': p.longitude,
      'image': p.image
    };
  }

  factory PositionModel.fromMap(Map<String, dynamic> map) {
    return PositionModel(addresse: map['addresse'] ?? "")
      ..description = (map['description'] ?? "")
      ..latitude = (map['latitude'] ?? "")
      ..longitude = (map['longitude'] ?? "")
      ..image = (map['image'] ?? "");
  }

  Map<String, dynamic> toMap() {
    return {
      'addresse': addresse,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'image': image
    };
  }
}
