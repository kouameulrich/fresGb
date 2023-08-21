// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, depend_on_referenced_packages, use_build_context_synchronously, unused_field

import 'package:appfres/_api/tokenStorageService.dart';
import 'package:appfres/db/local.service.dart';
import 'package:appfres/di/service_locator.dart';
import 'package:appfres/misc/printer.service.dart';
import 'package:appfres/models/dto/contract.dart';
import 'package:appfres/models/dto/customer.dart';
import 'package:appfres/models/payment.dart';
import 'package:appfres/models/user.dart';
import 'package:appfres/ui/pages/liste.payment.page.dart';
import 'package:appfres/ui/pages/login.page.dart';
import 'package:appfres/ui/pages/printing.page.dart';
import 'package:appfres/widgets/default.colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:uuid/uuid.dart';
import 'package:pdf/widgets.dart' as pw;

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key, required this.contract});

  final Contract contract;
  //final Payment payment;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final printerService = locator<PrinterService>();
  final _formKey = GlobalKey<FormState>();
  final dbHandler = locator<LocalService>();
  final storage = locator<TokenStorageService>();
  User? agentConnected;
  var clientId = "";
  String? statusPayment = "Uploaded to Digital-IT";

  String? _selectContract;
  List<Contract> contract = [];

  bool isUserLoggedIn() {
    return agentConnected != null;
  }

  Payment? payment;

  TextEditingController montantverseController = TextEditingController();

  Future<User?> getAgent() async {
    return await storage.retrieveAgentConnected();
  }

  Future<List<Contract>> getAllContract() async {
    return await dbHandler.readAllContract();
  }

  Future<List<Payment>> getAllPayment() async {
    return await dbHandler.readAllPayment();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('------- DATA -------');

      clientId = widget.contract.id.toString();

      getAgent().then((value) => setState(() {
            agentConnected = value;
          }));
    });
  }

  @override
  void dispose() {
    montantverseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Defaults.blueAppBar,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Pagamento de Fatura'),
          ],
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => PaymentListPage()));
            },
            icon: Icon(Icons.arrow_back_ios_new)),
        centerTitle: true,
      ),
      backgroundColor: Defaults.backgroundColorPage,
      body: Padding(
        padding:
            const EdgeInsets.only(bottom: 15, left: 15, right: 15, top: 15),
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(bottom: 15, left: 0, right: 0, top: 15),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informaçao Cliente',
                      style: TextStyle(
                          color: Defaults.bluePrincipal,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Appelido e nome: ${widget.contract.clientName}'),
                        SizedBox(
                          height: 5,
                        ),
                        Text('Offerta: ${widget.contract.offer} '),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Informaçao Contrato',
                      style: TextStyle(
                          color: Defaults.bluePrincipal,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Referencia: ${widget.contract.id} '),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 15, left: 0, right: 0, top: 15),
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: montantverseController,
                          keyboardType: TextInputType.number,
                          decoration:
                              InputDecoration(hintText: 'Montante a pagar'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 15, left: 0, right: 0, top: 15),
                      child: ElevatedButton(
                        onPressed: () async {
                          onSubmit();
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Defaults.bluePrincipal)),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 15, left: 0, right: 0, top: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.monetization_on),
                              Text(
                                'Pagar',
                                style: TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  onSubmit() async {
    if (_formKey.currentState!.validate()) {
      DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'CONFIRMAÇAO',
              textAlign: TextAlign.center,
            ),
            content: SizedBox(
              height: 150,
              child: Column(
                children: [
                  Lottie.asset(
                    'animations/recap.json',
                    repeat: true,
                    reverse: true,
                    fit: BoxFit.cover,
                    height: 130,
                  ),
                  const Text(
                    'Queria confirmar o pagamento dessa fatura ?',
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
                child: const Text('Nao'),
              ),
              TextButton(
                onPressed: () async {
                  if (agentConnected == null) {
                    // Handle the case when the agentConnected is null.
                    return;
                  }

                  String paymentId = Uuid()
                      .v4(); // Générer un identifiant unique pour le paiement

                  payment = Payment(
                    // Populate the payment object.
                    id: paymentId,
                    agent: agentConnected!.id,
                    contract: widget.contract.id,
                    amount: double.parse(montantverseController.text),
                    paymentDate: dateFormat.format(DateTime.now()),
                    status: statusPayment,
                  );

                  await dbHandler.SavePayment(payment!);
                  pw.Document docPage1 = await printerService.printEncaissement(
                      agentConnected!, widget.contract);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PrintingPage(
                        docPage: docPage1,
                      ),
                    ),
                  );
                },
                child: const Text('Sim'),
              ),
            ],
          );
        },
      );
    }
  }
}
