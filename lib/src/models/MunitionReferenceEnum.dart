enum MunitionReferenceEnum {
  OBUS_20_MM,
  GRENADE,
  OBUS_40_MM,
  MORTIER_60_MM,
  MORTIER_81_MM,
  OBUS_75_MM,
  OBUS_105_MM,
  BOMBE_200_LBS,
  BOMBE_500_LBS,
  BOMBE_1000_LBS;

  String toJson() => name;
  static MunitionReferenceEnum fromJson(String json) => values.byName(json);
}

extension MunitionReferenceEnumExtension on MunitionReferenceEnum {
  String get sentence {
    switch (this) {
      case MunitionReferenceEnum.OBUS_20_MM:
        return "Obus de 20 mm";
      case MunitionReferenceEnum.GRENADE:
        return "Grenade";
      case MunitionReferenceEnum.OBUS_40_MM:
        return "Obus de 40 mm";
      case MunitionReferenceEnum.MORTIER_60_MM:
        return "Mortier de 60 mm";
      case MunitionReferenceEnum.MORTIER_81_MM:
        return "Mortier de 81 mm";
      case MunitionReferenceEnum.OBUS_75_MM:
        return "Obus de 75 mm";
      case MunitionReferenceEnum.OBUS_105_MM:
        return "Obus de 105 mm";
      case MunitionReferenceEnum.BOMBE_200_LBS:
        return "Bombe de 200 lbs";
      case MunitionReferenceEnum.BOMBE_500_LBS:
        return "Bombe de 500 lbs";
      case MunitionReferenceEnum.BOMBE_1000_LBS:
        return "Bombe de 1000 lbs";
    }
  }
}
