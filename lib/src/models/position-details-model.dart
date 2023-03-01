class PositionDetailsModel {
  int? id;
  int? position_id;
  String? image;

  PositionDetailsModel({this.position_id, this.image});

  @override
  String toString() {
    return 'PositionDetails { id: $id, position_id: ${position_id.toString()}, image: $image}\n';
  }

  factory PositionDetailsModel.fromJson(Map<String, dynamic> json) {
    return PositionDetailsModel(
        position_id: json['position_id'] as int,
        image: json['image'] as String);
  }

  Map<String, dynamic> toJson(PositionDetailsModel p) {
    return {'image': p.image, 'position_id': p.position_id};
  }

  factory PositionDetailsModel.fromMap(Map<String, dynamic> map) {
    return PositionDetailsModel(position_id: map['position_id'] ?? "")
      ..image = (map['image'] ?? "");
  }

  Map<String, dynamic> toMap() {
    return {'position_id': position_id, 'image': image};
  }
}
