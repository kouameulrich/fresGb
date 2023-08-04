// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, depend_on_referenced_packages, use_build_context_synchronously

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
  const PaymentPage({super.key, required this.customer});

  final Customer customer;
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

  Future<List<Customer>> getAllClient() async {
    return await dbHandler.readAllClient();
  }

  Future<List<Contract>> getAllContract() async {
    return await dbHandler.getContractsPerClient(widget.customer.reference);
  }

  Future<List<Payment>> getAllPayment() async {
    return await dbHandler.readAllPayment();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('------- DATA -------');

      getAllClient().then((value) => setState(() {}));

      clientId = widget.customer.reference.toString();

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
            const Text('Paiement Facture'),
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
                      'Information Client',
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
                        Text(
                            'Nom et prenoms: ${widget.customer.firstName} ${widget.customer.lastName}'),
                        SizedBox(
                          height: 5,
                        ),
                        Text('Référence: ${widget.customer.reference} '),
                        SizedBox(
                          height: 5,
                        ),
                        Text('Localité: ${widget.customer.village}'),
                        SizedBox(
                          height: 5,
                        ),
                        Text('Numéro portable: ${widget.customer.phoneNumber}'),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Information Contrat',
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
                        FutureBuilder<List<Contract>>(
                          future: getAllContract(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text(
                                  'Erreur lors du chargement des contrats');
                            } else if (snapshot.data != null &&
                                snapshot.data!.isEmpty) {
                              return Text(
                                  'Aucun contrat trouvé pour ce client');
                            } else {
                              return DropdownButton<String>(
                                value: _selectContract,
                                hint: const Text('Select contract reference'),
                                items: snapshot.data!.map((contract) {
                                  return DropdownMenuItem(
                                    value: contract.reference,
                                    child: Text(contract.reference),
                                  );
                                }).toList(),
                                underline: const SizedBox(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectContract = value;
                                  });
                                },
                              );
                            }
                          },
                        ),
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
                          decoration: InputDecoration(hintText: 'Montant payé'),
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
                                'Payer',
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
    if (!isUserLoggedIn()) {
      // L'utilisateur n'est pas connecté, redirigez-le vers la page de connexion.
      // Vous pouvez utiliser la méthode Navigator.pushReplacement pour le rediriger.
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'ALERTE',
                textAlign: TextAlign.center,
              ),
              content: SizedBox(
                height: 120,
                child: Column(
                  children: [
                    Lottie.asset(
                      'animations/verif.json',
                      repeat: true,
                      reverse: true,
                      fit: BoxFit.cover,
                      height: 100,
                    ),
                    const Text(
                      'Veillez-vous connecter  . . .',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: const Text('Retry'),
                )
              ],
            );
          });
      return;
    }
    if (_formKey.currentState!.validate()) {
      DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm:ss");
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'CONFIRMATION',
              textAlign: TextAlign.center,
            ),
            content: SizedBox(
              height: 120,
              child: Column(
                children: [
                  Lottie.asset(
                    'animations/verif.json',
                    repeat: true,
                    reverse: true,
                    fit: BoxFit.cover,
                    height: 100,
                  ),
                  const Text(
                    'Voulez-vous payer cette facture ?',
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
                child: const Text('Non'),
              ),
              TextButton(
                onPressed: () async {
                  if (_selectContract == null) {
                    // Handle the case when no contract is selected.
                    return;
                  }

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
                    contract: _selectContract!,
                    amount: double.parse(montantverseController.text),
                    paymentDate: dateFormat.format(DateTime.now()),
                  );

                  await dbHandler.SavePayment(payment!);
                  pw.Document docPage1 = await printerService.printEncaissement(
                      agentConnected!, widget.customer);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PrintingPage(
                        docPage: docPage1,
                      ),
                    ),
                  );
                },
                child: const Text('Oui'),
              ),
            ],
          );
        },
      );
    }
  }
}
