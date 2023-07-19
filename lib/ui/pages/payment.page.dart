// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:appfres/_api/tokenStorageService.dart';
import 'package:appfres/db/local.service.dart';
import 'package:appfres/di/service_locator.dart';
import 'package:appfres/misc/printer.service.dart';
import 'package:appfres/models/dto/contract.dart';
import 'package:appfres/models/dto/customer.dart';
import 'package:appfres/models/user.dart';
import 'package:appfres/ui/pages/liste.payment.page.dart';
import 'package:appfres/widgets/default.colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

/// AFFICHAGE DU FORMULAIRE DE PAIEMENT
class PaymentPage extends StatefulWidget {
  PaymentPage({super.key, required this.customer});

  final Customer customer;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final printerService = locator<PrinterService>();
  final _formKey = GlobalKey<FormState>();
  final dbHandler = locator<LocalService>();
  final storage = locator<TokenStorageService>();
  late final Future<User?> _futureAgentConnected;
  User? agentConnected;
  var clientId = "";

  String? _selectedContractOffer;
  String? _selectedContractType;

  String? _selectContract;
  List<Contract> contract = [];

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

  @override
  void initState() {
    _futureAgentConnected = getAgent();
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
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
                        Text('Offer: '),
                        SizedBox(
                          height: 5,
                        ),
                        Text('Type: '),
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
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Entrer un montant';
                          //   } else if (double.parse(value)> double.parse(source))
                          // },
                          decoration: InputDecoration(hintText: 'Montant payé'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 15, left: 0, right: 0, top: 15),
                      child: ElevatedButton(
                        onPressed: () {},
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
}
