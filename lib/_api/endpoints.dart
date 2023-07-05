class Endpoints {
  Endpoints._();

  // base url
  static const String baseUrl = "https://web.simbo.me/api/simboweb";

  // receiveTimeout
  static const int receiveTimeout = 15000;

  // connectTimeout
  static const int connectionTimeout = 15000;

  static const String typeEquipements = '/typeequipements/simple/list';

  static const String secteurs = '/secteurs/simple/list';

  static const String activiteCommerciales =
      '/activitecommerciales/simple/list';

  static const String encaissements = '/recensements/simple/list';
}
