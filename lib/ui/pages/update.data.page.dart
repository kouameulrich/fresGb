// ignore_for_file: prefer_const_constructors, use_build_context_synchronously
import 'package:appfres/_api/apiService.dart';
import 'package:appfres/db/local.service.dart';
import 'package:appfres/di/service_locator.dart';
import 'package:appfres/models/dto/contract.dart';
import 'package:appfres/models/user.dart';
import 'package:appfres/ui/pages/home.page.dart';
import 'package:appfres/widgets/default.colors.dart';
import 'package:appfres/widgets/loading.indicator.dart';
import 'package:appfres/widgets/mydrawer.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class UpdateDataPage extends StatefulWidget {
  const UpdateDataPage({Key? key}) : super(key: key);

  @override
  State<UpdateDataPage> createState() => _UpdateDataPageState();
}

class _UpdateDataPageState extends State<UpdateDataPage> {
  final dbHandler = locator<LocalService>();
  User? agentConnected;
  final apiService = locator<ApiService>();
  Contract? contract;
  List<Contract> _contracts = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Defaults.appBarColor,
        title: const Text('Atualisaçao de data'),
        centerTitle: true,
      ),
      drawer: MyDrawer(),
      backgroundColor: Defaults.backgroundColorPage,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Card(
                  color: Colors.white,
                  elevation: 70,
                  child: SizedBox(
                    width: 310,
                    height: 310,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Text(
                            "Atualisaçao de data",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: 160,
                            child: Column(
                              children: [
                                Lottie.asset(
                                  'animations/sendData.json',
                                  repeat: true,
                                  reverse: true,
                                  fit: BoxFit.cover,
                                  height: 150,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: 250,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () => _submitLogin(),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Defaults.bottomColor)),
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.send,
                                      size: 25,
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      'Download',
                                      style: TextStyle(fontSize: 25),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _submitLogin() async {
    LoadingIndicatorDialog().show(context);

    try {
      List<Contract> _contracts = await apiService.getAllContracts();

      for (var contrat in _contracts) {
        await dbHandler.deleteAllContracts(contrat);
      }

      for (var contract in _contracts) {
        dbHandler.SaveContract(contract);
      }

      LoadingIndicatorDialog().dismiss();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            'SUCESSO',
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
            height: 120,
            child: Column(
              children: [
                Lottie.asset(
                  'animations/success.json',
                  repeat: true,
                  reverse: true,
                  fit: BoxFit.cover,
                  height: 100,
                ),
                const Text(
                  'Atualisaçao effectua com sucesso',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const HomePage()));
                },
                child: const Text('VOLTAR'))
          ],
        ),
      );
    } catch (e) {
      LoadingIndicatorDialog().dismiss();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'ERRO',
              textAlign: TextAlign.center,
            ),
            content: SizedBox(
              height: 150,
              child: Column(
                children: [
                  Lottie.asset(
                    'animations/error-dialog.json',
                    repeat: true,
                    reverse: true,
                    fit: BoxFit.cover,
                    height: 120,
                  ),
                  const Text(
                    'Erro occoreu durante atualiçao',
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
                  child: const Text('Tenta de novo'))
            ],
          );
        },
      );
    }
  }

  Future<void> _submitLogin1() async {
    LoadingIndicatorDialog().show(context);
    var statusCode = await apiService.getAllContracts();
    LoadingIndicatorDialog().dismiss(); // Fermer l'indicateur de chargement

    if (statusCode == 200) {
      _contracts =
          await apiService.getAllContracts(); // Remplir la liste _contracts

      for (var contrat in _contracts) {
        await dbHandler.deleteAllContracts(contrat);
      }

      for (var contract in _contracts) {
        dbHandler.SaveContract(contract);
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            'SUCESSO',
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
            height: 120,
            child: Column(
              children: [
                Lottie.asset(
                  'animations/success.json',
                  repeat: true,
                  reverse: true,
                  fit: BoxFit.cover,
                  height: 100,
                ),
                const Text(
                  'Atualisaçao effectua com sucesso',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const HomePage()));
                },
                child: const Text('VOLTAR'))
          ],
        ),
      );
    } else {
      LoadingIndicatorDialog().dismiss();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'ERRO',
              textAlign: TextAlign.center,
            ),
            content: SizedBox(
              height: 150,
              child: Column(
                children: [
                  Lottie.asset(
                    'animations/error-dialog.json',
                    repeat: true,
                    reverse: true,
                    fit: BoxFit.cover,
                    height: 120,
                  ),
                  const Text(
                    'Erro occoreu durante atualiçao',
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
                  child: const Text('Tenta de novo'))
            ],
          );
        },
      );
    }
  }
}
