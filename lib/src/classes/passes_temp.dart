import 'package:flutter_application/src/models/MunitionReferenceEnum.dart';

class PassesTemp {
  int id;
  MunitionReferenceEnum munitionReference;
  double profondeurSonde, gradientMag, profondeurSecurisee, coteSecurisee;

  PassesTemp(
      {required this.id,
      required this.munitionReference,
      required this.gradientMag,
      required this.profondeurSonde,
      required this.coteSecurisee,
      required this.profondeurSecurisee});
}
