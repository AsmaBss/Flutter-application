import 'package:flutter_application/src/models/MunitionReferenceEnum.dart';

class PasseModel {
  int? id;
  MunitionReferenceEnum? munitionReference;
  int? profondeurSonde;
  int? gradientMag;
  int? profondeurSecurisee;
  int? coteSecurisee;

  PasseModel(
      {this.id,
      this.munitionReference,
      this.profondeurSonde,
      this.gradientMag,
      this.profondeurSecurisee,
      this.coteSecurisee});

  @override
  String toString() {
    return 'Passe { id: $id, munitionReference: $munitionReference, '
        'profondeurSonde: $profondeurSonde, gradientMag: $gradientMag,  '
        'profondeurSecurisee: $profondeurSecurisee, coteSecurisee: $coteSecurisee}\n';
  }

  factory PasseModel.fromJson(Map<String, dynamic> json) {
    return PasseModel(
      id: json['id'] as int,
      munitionReference:
          MunitionReferenceEnum.fromJson(json['munitionReference']),
      profondeurSonde: json['profondeurSonde'] as int,
      gradientMag: json['gradientMag'] as int,
      profondeurSecurisee: json['profondeurSecurisee'] as int,
      coteSecurisee: json['coteSecurisee'] as int,
    );
  }

  Map<String, dynamic> toJson(PasseModel p) {
    return {
      'id': p.id,
      'munitionReference': p.munitionReference!.toJson(),
      'profondeurSonde': p.profondeurSonde,
      'gradientMag': p.gradientMag,
      'profondeurSecurisee': p.profondeurSecurisee,
      'coteSecurisee': p.coteSecurisee,
    };
  }

  factory PasseModel.fromMap(Map<String, dynamic> map) {
    return PasseModel(munitionReference: map['munitionReference'] ?? "")
      ..profondeurSonde = (map['profondeurSonde'] ?? "")
      ..gradientMag = (map['gradientMag'] ?? "")
      ..profondeurSecurisee = (map['profondeurSecurisee'] ?? "")
      ..coteSecurisee = (map['coteSecurisee'] ?? "");
  }

  Map<String, dynamic> toMap() {
    return {
      'munitionReference': munitionReference,
      'profondeurSonde': profondeurSonde,
      'gradientMag': gradientMag,
      'profondeurSecurisee': profondeurSecurisee,
      'coteSecurisee': coteSecurisee,
    };
  }
}
