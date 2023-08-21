// // ignore_for_file: deprecated_member_use

// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:appfres/_api/tokenStorageService.dart';
import 'package:appfres/di/service_locator.dart';
import 'package:appfres/models/user.dart';
import 'package:appfres/ui/pages/home.page.dart';
import 'package:appfres/ui/pages/liste.payment.page.dart';
import 'package:appfres/ui/pages/login.page.dart';
import 'package:appfres/widgets/default.colors.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  final storage = locator<TokenStorageService>();

  String token = '';
  String lastConnected = '';

  Future<User?> getAgent() async {
    return await storage.retrieveAgentConnected();
  }

  @override
  void initState() {
    super.initState();
    navigateToNextScreen();
  }

  Future<void> navigateToNextScreen() async {
    final agent = await getAgent();
    lastConnected = agent?.lastConnection ?? '';
    token = agent?.token ?? '';

    if (lastConnected.isNotEmpty &&
        DateTime.parse(lastConnected).isAfter(
          DateTime.now().subtract(const Duration(days: 7)),
        )) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Defaults.backgroundColorPage,
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 250,
            ),
            Image.asset(
              'images/img.png',
              width: 250,
              height: 150,
            ),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              width: 200,
              child: LinearPercentIndicator(
                width: 200,
                animation: true,
                lineHeight: 10.0,
                animationDuration: 3000,
                percent: 1,
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: Defaults.appBarColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
