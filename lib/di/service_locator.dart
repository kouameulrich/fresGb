import 'package:appfres/_api/apiService.dart';
import 'package:appfres/_api/authService.dart';
import 'package:appfres/_api/dioClient.dart';
import 'package:appfres/_api/tokenStorageService.dart';
import 'package:appfres/db/database.connection.dart';
import 'package:appfres/db/local.service.dart';
import 'package:appfres/db/repository.dart';
import 'package:appfres/misc/printer.service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

Future<void> setup() async {
  locator.registerSingleton(const FlutterSecureStorage());
  locator
      .registerSingleton(TokenStorageService(locator<FlutterSecureStorage>()));
  locator.registerSingleton(Dio());
  locator.registerSingleton(AuthService(locator<TokenStorageService>()));
  locator.registerSingleton(DioClient(locator<Dio>()));
  locator.registerSingleton(ApiService(locator<DioClient>()));
  locator.registerSingleton(DatabaseConnection());
  locator.registerSingleton(Repository(locator<DatabaseConnection>()));
  locator.registerSingleton(LocalService(locator<Repository>()));
  locator.registerSingleton(PrinterService());
}
