class ImagesObservationModel {
  int? id;
  String? image;
  int? observation;

  ImagesObservationModel({this.id, this.image, this.observation});

  @override
  String toString() {
    return 'Images { id: $id, image: $image, observation : $observation}\n';
  }

  factory ImagesObservationModel.fromJson(Map<String, dynamic> json) {
    return ImagesObservationModel(
      id: json['id'] as int,
      image: json['image'] as String,
      observation: json['observation']['id'] as int,
    );
  }

  Map<String, dynamic> toJson(ImagesObservationModel p) {
    return {
      'id': p.id,
      'image': p.image,
      'observation': p.observation,
    };
  }

  factory ImagesObservationModel.fromMap(Map<String, dynamic> map) {
    return ImagesObservationModel(id: map['id'] ?? "")
      ..image = (map['image'] ?? "")
      ..observation = (map['observation'] ?? "");
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'observation': observation,
      'image': image,
    };
  }
}
