import 'package:flutter_application/src/models/MunitionReferenceEnum.dart';

class PasseModel {
  int? id;
  MunitionReferenceEnum munitionReference;
  double? profondeurSonde;
  double? gradientMag;
  double? profondeurSecurisee;
  double? coteSecurisee;
  int? prelevement;

  PasseModel(
      {this.id,
      required this.munitionReference,
      this.profondeurSonde,
      this.gradientMag,
      this.profondeurSecurisee,
      this.coteSecurisee,
      this.prelevement});

  @override
  String toString() {
    return 'Passe { id: $id, munitionReference: $munitionReference, '
        'profondeurSonde: $profondeurSonde, gradientMag: $gradientMag,  '
        'profondeurSecurisee: $profondeurSecurisee, coteSecurisee: $coteSecurisee, prelevement: $prelevement}\n';
  }

  factory PasseModel.fromJson(Map<String, dynamic> json) {
    return PasseModel(
      id: json['id'] as int,
      munitionReference:
          MunitionReferenceEnum.fromJson(json['munitionReference']),
      profondeurSonde: json['profondeurSonde'] as double,
      gradientMag: json['gradientMag'] as double,
      profondeurSecurisee: json['profondeurSecurisee'] as double,
      coteSecurisee: json['coteSecurisee'] as double,
      prelevement: json['prelevement']['id'] as int,
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
      'prelevement': p.prelevement,
    };
  }

  factory PasseModel.fromMap(Map<String, dynamic> map) {
    return PasseModel(
        id: map['id'],
        munitionReference:
            MunitionReferenceEnum.fromJson(map['munitionReference']),
        profondeurSonde: map['profondeurSonde'],
        gradientMag: map['gradientMag'],
        coteSecurisee: map['coteSecurisee'],
        profondeurSecurisee: map['profondeurSecurisee'],
        prelevement: map['prelevement']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'munitionReference': munitionReference.toJson(),
      'profondeurSonde': profondeurSonde,
      'gradientMag': gradientMag,
      'profondeurSecurisee': profondeurSecurisee,
      'coteSecurisee': coteSecurisee,
      'prelevement': prelevement,
    };
  }
}
