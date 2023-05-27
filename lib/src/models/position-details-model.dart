class PositionDetailsModel {
  int? id;
  int? positionId;
  String? image;

  PositionDetailsModel({this.positionId, this.image});

  @override
  String toString() {
    return 'PositionDetails { id: $id, positionId: ${positionId.toString()}, image: $image}\n';
  }

  factory PositionDetailsModel.fromJson(Map<String, dynamic> json) {
    return PositionDetailsModel(
        positionId: json['positionId'] as int, image: json['image'] as String);
  }

  Map<String, dynamic> toJson(PositionDetailsModel p) {
    return {'image': p.image, 'positionId': p.positionId};
  }

  factory PositionDetailsModel.fromMap(Map<String, dynamic> map) {
    return PositionDetailsModel(positionId: map['positionId'] ?? "")
      ..image = (map['image'] ?? "");
  }

  Map<String, dynamic> toMap() {
    return {'positionId': positionId, 'image': image};
  }
}
