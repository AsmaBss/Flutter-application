class ImagesModel {
  int? id;
  String? image;
  int? position_id;

  ImagesModel({this.id, this.image, this.position_id});

  @override
  String toString() {
    return 'Images { id: $id, image: $image, position_id: $position_id}\n';
  }

  factory ImagesModel.fromJson(Map<String, dynamic> json) {
    return ImagesModel(
        image: json['image'] as String,
        position_id: json['position_id'] as int);
  }

  Map<String, dynamic> toJson(ImagesModel p) {
    return {'image': p.image, 'position_id': p.position_id};
  }

  factory ImagesModel.fromMap(Map<String, dynamic> map) {
    return ImagesModel(image: map['image'] ?? "")
      ..position_id = (map['position_id'] ?? "");
  }

  Map<String, dynamic> toMap() {
    return {'image': image, 'position_id': position_id};
  }
}
