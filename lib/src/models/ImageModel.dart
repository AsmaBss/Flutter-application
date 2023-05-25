class ImageModel {
  int? id;
  String? image;
  int? prelevement;

  ImageModel({this.id, this.image, this.prelevement});

  @override
  String toString() {
    return 'Images { id: $id, image: $image, prelevement: $prelevement}\n';
  }

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
        id: json['id'] as int,
        image: json['image'] as String,
        prelevement: json['prelevement'] as int);
  }

  Map<String, dynamic> toJson(ImageModel p) {
    return {'id': p.id, 'image': p.image, 'prelevement': p.prelevement};
  }

  factory ImageModel.fromMap(Map<String, dynamic> map) {
    return ImageModel(image: map['image'] ?? "")
      ..prelevement = (map['prelevement'] ?? "");
  }

  Map<String, dynamic> toMap() {
    return {'image': image, 'prelevement': prelevement};
  }
}
