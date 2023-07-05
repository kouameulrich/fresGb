// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:appfres/ui/pages/home.page.dart';
import 'package:appfres/widgets/default.colors.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    });
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
