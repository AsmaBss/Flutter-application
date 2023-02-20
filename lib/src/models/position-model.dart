import 'dart:convert';

class PositionModel {
  String? id, addresse, description, latitude, longitude;

  PositionModel(
      {this.addresse, this.description, this.latitude, this.longitude});

  @override
  String toString() {
    return 'Position{address: $addresse, description: $description, latitude: $latitude, longitude: $longitude}';
  }

  factory PositionModel.fromJson(Map<String, dynamic> json) {
    return PositionModel(
      addresse: json['addresse'] as String,
      description: json['description'] as String,
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
    );
  }
}
