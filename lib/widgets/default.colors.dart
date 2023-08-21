import 'package:flutter/material.dart';

class Defaults {
  //static const Color drawerItemColor = Colors.green;
  static final Color? drawerItemSelectedColor = Colors.green[700];
  static final Color? drawerSelectedTileColor = Colors.green[100];
  static const Color backgroundColorPage = Color.fromRGBO(232, 244, 251, 1);
  static const Color bottomColor = Color.fromRGBO(20, 201, 166, 1);
  static const Color appBarColor = Color.fromRGBO(15, 81, 105, 1);
  static const Color libelleColor = Color.fromRGBO(17, 80, 107, 1);
  static const Color textColor = Color.fromRGBO(19, 76, 104, 1);
  static const Color bluePrincipal = Color(0xFF0f5169);
  static const Color greenPrincipal = Color(0xFF14c9a6);
  static const Color greenSelected = Color(0xFF59f1d3);
  static const Color blueFondCadre = Color(0xFFe8f6f9);
  static const Color blueAppBar = Color.fromRGBO(15, 81, 105, 1);
  static const Color white = Color.fromARGB(255, 255, 255, 255);

  static final drawerItemText = [
    'Inicio',
    'Coleçao',
    'Transferencia de data',
    'Atualisaçao de data',
  ];

  static final drawerItemIcon = [
    Icons.home,
    Icons.edit,
    Icons.send,
    Icons.update,
  ];
}
