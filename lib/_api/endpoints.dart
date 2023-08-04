class Endpoints {
  Endpoints._();

  // base url
  static const String baseUrl = "http://192.168.1.8:8080";

  // receiveTimeout
  static const int receiveTimeout = 15000;

  // connectTimeout
  static const int connectionTimeout = 15000;

  static const String contracts = '/api/public/allContracts';

  static const String clients = '/api/public/allClient';

  static const String payments = '/api/public/allPayments';

  static const String users = '/api/public/allUsers';

  static const String paiementFacture = '/api/public/bulkPayments';
}
