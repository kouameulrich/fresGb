import 'dart:io';

import 'package:appfres/di/service_locator.dart';
import 'package:appfres/ui/pages/home.page.dart';
import 'package:appfres/ui/pages/liste.encaissement.page.dart';
import 'package:appfres/ui/pages/log.page.dart';
import 'package:appfres/ui/pages/splash.screnn.page.dart';
import 'package:appfres/ui/pages/transfert.page.dart';
import 'package:appfres/widgets/navigator_key.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

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
  HttpOverrides.global = DevHttpOverrides();
  setup();
  runApp(const OverlaySupport.global(
    child: MaterialApp(home: MyApp()),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      routes: {
        '/': (context) => const SplashScreen(),
        '/loginpage': (context) => LoginScreen(),
        '/home': (context) => const HomePage(),
        '/listerecensement': (context) => const ListeEncaissementPage(),
        '/transfert': (context) => const TransfertDonnees(),
      },
      title: 'FresGB App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
    );
  }
}
