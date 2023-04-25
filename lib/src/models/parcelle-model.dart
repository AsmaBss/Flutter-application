import 'package:dart_jts/dart_jts.dart';
import 'package:geojson/geojson.dart';

class ParcelleModel {
  int? id;
  String? file;
  String? type;
  String? geometry;

  ParcelleModel({this.id, this.file, this.type, this.geometry});

  @override
  String toString() {
    return 'Parcelle { id: $id, file: $file, '
        'type: $type, geometry: $geometry}\n';
  }

  factory ParcelleModel.fromJson(Map<String, dynamic> json) {
    return ParcelleModel(
      id: json['id'] as int,
      file: json['file'] as String,
      type: json['type'] as String,
      geometry: json['geometry']['coordinates'] as String,
      /*geometry: WKTReader().read(json['geometry'] is String
          ? json['geometry']
          : json['geometry'].toString()),*/
    );
  }

  Map<String, dynamic> toJson(ParcelleModel p) {
    return {
      'id': p.id,
      'file': p.file,
      'type': p.type,
      'geometry': p.geometry, //?.toText()
    };
  }

  factory ParcelleModel.fromMap(Map<String, dynamic> map) {
    return ParcelleModel(file: map['file'] ?? "")
      ..type = (map['type'] ?? "")
      ..geometry = (map['geometry'] ?? "");
  }

  Map<String, dynamic> toMap() {
    return {'file': file, 'type': type, 'geometry': geometry};
  }
}
