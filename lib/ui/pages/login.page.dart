// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'dart:developer';

import 'package:appfres/_api/apiService.dart';
import 'package:appfres/_api/authService.dart';
import 'package:appfres/_api/tokenStorageService.dart';
import 'package:appfres/db/local.service.dart';
import 'package:appfres/di/service_locator.dart';
import 'package:appfres/models/agent.dart';
import 'package:appfres/ui/pages/home.page.dart';
import 'package:appfres/widgets/default.colors.dart';
import 'package:appfres/widgets/error.dialog.dart';
import 'package:appfres/widgets/loading.indicator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final authService = locator<AuthService>();
  final apiService = locator<ApiService>();
  final dbHandler = locator<LocalService>();
  final storage = locator<TokenStorageService>();
  final TextEditingController _tenantController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool notvisible = true;
  Agent? agentConnected;
  bool isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _tenantController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Defaults.backgroundColorPage,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40, bottom: 30),
                child: Center(
                  child: Container(
                    child: Image.asset(
                      'images/img.png',
                    ),
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                child: Container(
                  height: 55,
                  padding: const EdgeInsets.only(top: 3, left: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: _usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Entrer un nom utilisateur';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter votre nom utilisateur'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                child: Container(
                  height: 55,
                  padding: const EdgeInsets.only(top: 3, left: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Entrer un mot de passe';
                      }
                      return null;
                    },
                    obscureText: notvisible,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                            icon: Icon(notvisible
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                notvisible = !notvisible;
                              });
                            }),
                        border: InputBorder.none,
                        hintText: 'Entrer votre mot de passe'),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 35, bottom: 0),
                  child: Container(
                    height: 50,
                    width: 500,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Defaults.bottomColor,
                      ),
                      child: const Text('Connexion',
                          style: TextStyle(color: Colors.white, fontSize: 25)),
                      onPressed: () async {
                        _submitLogin();
                      },
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitLogin() async {
    if (_formKey.currentState!.validate()) {
      LoadingIndicatorDialog().show(context);
      log(_tenantController.text);
      try {
        var statusCode = await authService.authenticateUser(
            _tenantController.text.trim(),
            _usernameController.text.trim(),
            _passwordController.text);
        if (statusCode == 200) {
          LoadingIndicatorDialog().dismiss();
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const HomePage()));
        }
      } on DioError catch (e) {
        LoadingIndicatorDialog().dismiss();
        ErrorDialog().show(e);
      }
    }
  }
}
