// ignore_for_file: use_build_context_synchronously

import 'package:appfres/_api/apiService.dart';
import 'package:appfres/_api/tokenStorageService.dart';
import 'package:appfres/db/local.service.dart';
import 'package:appfres/di/service_locator.dart';
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
                        return 'Entrez un nom d\'utilisateur';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Entrez votre nom d\'utilisateur'),
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
                        return 'Entrez un mot de passe';
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
                        hintText: 'Entrez votre mot de passe'),
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
      var statusCode = await authService.authenticateUser(
          usernameController.text.trim(), passwordController.text.trim());
      if (statusCode == 200) {
        //load customer
        List<Customer> customers = await apiService.getAllClients();
        for (var customer in customers) {
          dbHandler.SaveCustomer(customer);
          for (var contract in customer.contracts) {
            contract.client_id = customer.reference.toString();
            dbHandler.SaveContract(contract);
          }
        }

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
                ),
                content: SizedBox(
                  height: 120,
                  child: Column(
                    children: [
                      Lottie.asset(
                        'animations/auth.json',
                        repeat: true,
                        reverse: true,
                        fit: BoxFit.cover,
                        height: 100,
                      ),
                      const Text(
                        'Incorrect username and or password',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Retry'))
                ],
              );
            });
      }
    }
  }
}
