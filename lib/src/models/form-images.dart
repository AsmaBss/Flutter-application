import 'package:flutter_application/src/models/form-marker-model.dart';

class FormImagesModel {
  List? images;
  FormMarkerModel? formMarker;

  FormImagesModel({this.images, this.formMarker});

  @override
  String toString() {
    return 'FormMarkerImages { images: $images, formMarker: $formMarker}\n';
  }

  factory FormImagesModel.fromJson(Map<String, dynamic> json) {
    return FormImagesModel(
        formMarker: json['formMarker'] as FormMarkerModel,
        images: json['images'] as List);
  }

  Map<String, dynamic> toJson(FormImagesModel fi) {
    return {'formMarker': fi.formMarker, 'images': fi.images};
  }
}
