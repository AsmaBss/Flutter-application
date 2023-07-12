class ImageModel {
  int? id;
  String? image;

  ImageModel({this.id, this.image});

  @override
  String toString() {
    return 'Images { id: $id, image: $image}\n';
  }

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(id: json['id'] as int, image: json['image'] as String);
  }

  Map<String, dynamic> toJson(ImageModel p) {
    return {'id': p.id, 'image': p.image};
  }

  factory ImageModel.fromMap(Map<String, dynamic> map) {
    return ImageModel(image: map['image'] ?? "");
  }

  Map<String, dynamic> toMap() {
    return {'image': image};
  }
}
