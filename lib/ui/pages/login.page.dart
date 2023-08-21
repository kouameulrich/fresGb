// ignore_for_file: use_build_context_synchronously

import 'package:appfres/_api/apiService.dart';
import 'package:appfres/_api/tokenStorageService.dart';
import 'package:appfres/db/local.service.dart';
import 'package:appfres/di/service_locator.dart';
import 'package:appfres/models/dto/contract.dart';
import 'package:appfres/models/dto/customer.dart';
import 'package:appfres/models/user.dart';
import 'package:appfres/ui/pages/home.page.dart';
import 'package:appfres/widgets/default.colors.dart';
import 'package:appfres/widgets/loading.indicator.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../_api/authService.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final authService = locator<AuthService>();
  final dbHandler = locator<LocalService>();
  final apiService = locator<ApiService>();
  final storage = locator<TokenStorageService>();
  final _formKey = GlobalKey<FormState>();
  bool notvisible = true;
  User? agentConnected;
  bool isLoading = false;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40, bottom: 30),
                child: Center(
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0)),
                    child: Image.asset(
                      'images/img.png',
                    ),
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
                    controller: usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Entra nome de usurio';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Entra nome de usurio'),
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
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Entra senha';
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
                        hintText: 'Entra senha'),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 35, bottom: 0),
                  child: SizedBox(
                    height: 50,
                    width: 500,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Defaults.bottomColor,
                      ),
                      child: const Text('Conexao',
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
      var statusCode = await authService.authenticateUser(
          usernameController.text.trim(), passwordController.text.trim());
      if (statusCode == 200) {
        //LOAD CONTRACT
        // List<Contract> contracts = await apiService.getAllContracts();
        // for (var contract in contracts) {
        //   dbHandler.SaveContract(contract);
        // }

        LoadingIndicatorDialog().dismiss();
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const HomePage()));
      } else {
        LoadingIndicatorDialog().dismiss();
        return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                'ERROR',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SizedBox(
                height: 170,
                child: Column(
                  children: [
                    Lottie.asset(
                      'animations/not_found.json',
                      repeat: true,
                      reverse: true,
                      fit: BoxFit.cover,
                      height: 150,
                    ),
                    const Text(
                      'Usuario ou Senha Incorreto',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Tenta Mais'))
              ],
            );
          },
        );
      }
    }
  }
}
