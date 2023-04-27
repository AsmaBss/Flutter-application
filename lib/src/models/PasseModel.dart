class PasseModel {
  int? id;
  String? munitionReference;
  int? profondeurSonde;
  int? gradientMag;
  int? profondeurSecurisee;
  int? coteSecurisee;
  int? prelevement;

  PasseModel(
      {this.id,
      this.munitionReference,
      this.profondeurSonde,
      this.gradientMag,
      this.profondeurSecurisee,
      this.coteSecurisee,
      this.prelevement});

  @override
  String toString() {
    return 'Prevelement { id: $id, munitionReference: $munitionReference, '
        'profondeurSonde: $profondeurSonde, gradientMag: $gradientMag,  '
        'profondeurSecurisee: $profondeurSecurisee, coteSecurisee: $coteSecurisee, prelevement: $prelevement}\n';
  }

  factory PasseModel.fromJson(Map<String, dynamic> json) {
    return PasseModel(
      id: json['id'] as int,
      munitionReference: json['munitionReference'] as String,
      profondeurSonde: json['profondeurSonde'] as int,
      gradientMag: json['gradientMag'] as int,
      profondeurSecurisee: json['profondeurSecurisee'] as int,
      coteSecurisee: json['coteSecurisee'] as int,
      prelevement: json['prelevement'] as int,
    );
  }

  Map<String, dynamic> toJson(PasseModel p) {
    return {
      'id': p.id,
      'munitionReference': p.munitionReference,
      'profondeurSonde': p.profondeurSonde,
      'gradientMag': p.gradientMag,
      'profondeurSecurisee': p.profondeurSecurisee,
      'coteSecurisee': p.coteSecurisee,
      'prelevement': p.prelevement,
    };
  }

  factory PasseModel.fromMap(Map<String, dynamic> map) {
    return PasseModel(munitionReference: map['munitionReference'] ?? "")
      ..profondeurSonde = (map['profondeurSonde'] ?? "")
      ..gradientMag = (map['gradientMag'] ?? "")
      ..profondeurSecurisee = (map['profondeurSecurisee'] ?? "")
      ..coteSecurisee = (map['coteSecurisee'] ?? "")
      ..prelevement = (map['prelevement'] ?? "");
  }

  Map<String, dynamic> toMap() {
    return {
      'munitionReference': munitionReference,
      'profondeurSonde': profondeurSonde,
      'gradientMag': gradientMag,
      'profondeurSecurisee': profondeurSecurisee,
      'coteSecurisee': coteSecurisee,
      'prelevement': prelevement,
    };
  }
}
