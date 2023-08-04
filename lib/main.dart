import 'dart:io';

import 'package:appfres/di/service_locator.dart';
import 'package:appfres/ui/pages/home.page.dart';
import 'package:appfres/ui/pages/liste.payment.page.dart';
import 'package:appfres/ui/pages/login.page.dart';
import 'package:appfres/ui/pages/splash.screnn.page.dart';
import 'package:appfres/ui/pages/transfert.page.dart';
import 'package:appfres/ui/pages/update.data.page.dart';
import 'package:appfres/widgets/navigator_key.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  HttpOverrides.global = DevHttpOverrides();
  setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        navigatorKey: navigatorKey,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/loginpage': (context) => const LoginPage(),
          '/home': (context) => const HomePage(),
          '/listepayment': (context) => const PaymentListPage(),
          '/transfert': (context) => const TransfertDonnees(),
          '/miseajour': (context) => const UpdateDataPage(),
        },
        title: 'FresGB App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
      ),
    );
  }
}
