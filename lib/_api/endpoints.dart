class Endpoints {
  Endpoints._();

  // base url
  static const String baseUrl = "https://www.digitale-it.com/fres";

  // receiveTimeout
  static const int receiveTimeout = 15000;

  // connectTimeout
  static const int connectionTimeout = 15000;

  static const String contracts = '/api/public/allContracts';

  static const String payments = '/api/public/allPayments';

  static const String users = '/api/public/allUsers';

  static const String paiementFacture = '/api/public/bulkPayments';
}
