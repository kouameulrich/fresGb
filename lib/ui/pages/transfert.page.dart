// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, unused_field
import 'dart:convert';

import 'package:appfres/_api/apiService.dart';
import 'package:appfres/_api/tokenStorageService.dart';
import 'package:appfres/db/local.service.dart';
import 'package:appfres/di/service_locator.dart';
import 'package:appfres/models/payment.dart';
import 'package:appfres/models/user.dart';
import 'package:appfres/ui/pages/home.page.dart';
import 'package:appfres/widgets/default.colors.dart';
import 'package:appfres/widgets/loading.indicator.dart';
import 'package:appfres/widgets/mydrawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;

class TransfertDonnees extends StatefulWidget {
  const TransfertDonnees({Key? key}) : super(key: key);

  @override
  State<TransfertDonnees> createState() => _TransfertDonneesState();
}

class _TransfertDonneesState extends State<TransfertDonnees> {
  final dbHandler = locator<LocalService>();
  final apiService = locator<ApiService>();
  final storage = locator<TokenStorageService>();

  List<Payment> _payments = [];
  final List<Payment> _facturePayments = [];

  int _countEncaissement = 0;
  double _montantCollecte = 0.0;

  String userid = '';
  String token = '';

  Future<List<Payment>>? _futureEncaissement;

  Future<List<Payment>> getAllEncaissement() async {
    return await dbHandler.readAllPayment();
  }

  Future<User?> getAgent() async {
    return await storage.retrieveAgentConnected();
  }

  @override
  void initState() {
    _futureEncaissement = getAllEncaissement();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // do something
      getAgent().then((value) {
        userid = value!.id!;
        token = value.token!;
      });
      getAllEncaissement().then((value) => {
            setState(() {
              _payments = value;
              _countEncaissement = value.length;
              _montantCollecte = _payments.toList().fold(
                  0, (value, element) => value.toDouble() + element.amount!);
              // Afficher tous les paiements dans le log
              for (var payment in _payments) {}
            })
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Defaults.appBarColor,
        title: const Text('Transferir'),
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
                    width: 300,
                    height: 300,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Text(
                            "Coleção",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              // color: Defaults.appBarColor,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Numero: $_countEncaissement',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Defaults.bluePrincipal),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  NumberFormat.currency(
                                          decimalDigits: 0, name: '')
                                      .format(_montantCollecte),
                                  style: TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                      color: Defaults.bluePrincipal),
                                ),
                                Text(
                                  'FCFA',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Defaults.greenSelected),
                                ),
                                Text(
                                  'Montante Coletado',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Defaults.bluePrincipal),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 13,
                          ),
                          SizedBox(
                            width: 250,
                            child: ElevatedButton(
                              onPressed: () => sendData(),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Defaults.bottomColor)),
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.send),
                                    Text(
                                      'Transferir',
                                      style: TextStyle(fontSize: 20),
                                    )
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

  void sendData() async {
    LoadingIndicatorDialog().show(context);

    var headersList = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var url = Uri.parse(
        'https://www.digitale-it.com/fres/api/payment/bulkPayments/$userid');

    // Assurez-vous que _payments n'est pas vide avant de continuer
    if (_payments.isNotEmpty) {
      var body = [];

      // Parcourir chaque paiement et les ajouter à la liste body
      for (var payment in _payments) {
        body.add({
          "agent": {"id": payment.agent},
          "contract": {"id": payment.contract},
          "amount": payment.amount,
          "paymentDate": payment.paymentDate.toString(),
          "status": payment.status,
        });
      }

      var req = http.Request('POST', url);
      req.headers.addAll(headersList);
      req.body = json.encode(body);

      var res = await req.send();

      LoadingIndicatorDialog().dismiss();

      ///-------- POPU UP OF SUCCESS ---------//
      if (res.statusCode >= 200 && res.statusCode < 300) {
        // Supprimer les données après l'envoi réussi
        for (var payment in _payments) {
          await dbHandler.deletePayment(
              "'${payment.id}'"); // En entourant l'identifiant avec des guillemets simples
        }
        return showDialog(
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
                    'Pagamento enviado com sucesso',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const HomePage()));
                  },
                  child: const Text('VOLTAR'))
            ],
          ),
        );
      } else {
        setState(() {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text(
                'ERRO',
                textAlign: TextAlign.center,
              ),
              content: SizedBox(
                height: 120,
                child: Column(
                  children: [
                    Lottie.asset(
                      'animations/error-dialog.json',
                      repeat: true,
                      reverse: true,
                      fit: BoxFit.cover,
                      height: 100,
                    ),
                    const Text(
                      'Erro occoreu durante a transaçao',
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
            ),
          );
        });
      }
    } else {}
  }
}
