class ImagesObservationModel {
  int? id;
  String? image;

  ImagesObservationModel({this.id, this.image});

  @override
  String toString() {
    return 'Images { id: $id, image: $image}\n';
  }

  factory ImagesObservationModel.fromJson(Map<String, dynamic> json) {
    return ImagesObservationModel(
        id: json['id'] as int, image: json['image'] as String);
  }

  Map<String, dynamic> toJson(ImagesObservationModel p) {
    return {'id': p.id, 'image': p.image};
  }

  factory ImagesObservationModel.fromMap(Map<String, dynamic> map) {
    return ImagesObservationModel(image: map['image'] ?? "");
  }

  Map<String, dynamic> toMap() {
    return {'image': image};
  }
}
