enum StatutEnum {
  Securise,
  A_Verifier,
  Non_Securise;

  String toJson() => name;
  static StatutEnum fromJson(String json) => values.byName(json);
}

extension StatutEnumExtension on StatutEnum {
  String get sentence {
    switch (this) {
      case StatutEnum.Securise:
        return "Sécurisé";
      case StatutEnum.A_Verifier:
        return "A vérifier";
      case StatutEnum.Non_Securise:
        return "Non sécurisé";
    }
  }
}
