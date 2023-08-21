// ignore_for_file: prefer_const_constructors, unused_field, unnecessary_string_interpolations

import 'package:appfres/_api/apiService.dart';
import 'package:appfres/_api/tokenStorageService.dart';
import 'package:appfres/db/local.service.dart';
import 'package:appfres/di/service_locator.dart';
import 'package:appfres/misc/printer.service.dart';
import 'package:appfres/models/dto/contract.dart';
import 'package:appfres/models/user.dart';
import 'package:appfres/ui/pages/payment.page.dart';
import 'package:appfres/widgets/default.colors.dart';
import 'package:appfres/widgets/mydrawer.dart';
import 'package:flutter/material.dart';

class PaymentListPage extends StatefulWidget {
  const PaymentListPage({Key? key}) : super(key: key);

  @override
  State<PaymentListPage> createState() => _PaymentListPageState();
}

class _PaymentListPageState extends State<PaymentListPage> {
  final printerService = locator<PrinterService>();
  final apiService = locator<ApiService>();
  final dbHandler = locator<LocalService>();
  final storage = locator<TokenStorageService>();
  late final Future<User?> _futureAgentConnected;
  User? agentConnected;

  //------ client declaration ------
  // Customer? customer;
  // List<Customer> _customers = [];
  // int _countCustomer = 0;
  // final int _countCustomerPay = 0;

  String? _selectContract;
  List<Contract> _contracts = [];
  Contract? contract;
  int _countContract = 0;
  final int _countContractPay = 0;

  TextEditingController searchController = TextEditingController();

  Future<User?> getAgent() async {
    return await storage.retrieveAgentConnected();
  }

  Future<List<Contract>> getAllContract() async {
    return await dbHandler.readAllContract();
  }

  // Future<List<Contract>> getAllContract() async {
  //   return await dbHandler.getContractsPerClient(_customers);
  // }

  String _searchText = ''; // Variable pour stocker le texte de recherche

  void filterClients(String searchText) {
    setState(() {
      _searchText = searchText; // Met à jour le texte de recherche
      _contracts = _contracts
          .where((element) =>
              element.offer!.contains(searchText) ||
              element.id
                  .toLowerCase()
                  .contains(searchText.toString().toLowerCase()) ||
              element.clientName!
                  .toLowerCase()
                  .contains(searchText.toString().toLowerCase()))
          .toList();
      _countContract = _contracts.length;
    });
  }

  // @override
  // void initState() {
  //   _futureAgentConnected = getAgent();
  //   print('------- DATA -------');
  //   print(_contracts);

  //   getAllContract().then(
  //     (value) => _contracts = value,
  //   );

  //   getAgent().then((value) => agentConnected = value);
  //   super.initState();
  // }

  @override
  void initState() {
    _futureAgentConnected = getAgent();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('------- DATA -------');

      getAllContract().then((value) => setState(() {
            _countContract = value.length;
            _contracts = value;
            // _contracts.sort();
          }));

      getAgent().then((value) => setState(() {
            agentConnected = value;
          }));
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    searchController.dispose();
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
            const Text('Coleção'),
            Text(
              '$_countContractPay/$_countContract',
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
        centerTitle: true,
      ),
      drawer: MyDrawer(),
      floatingActionButton: _countContractPay == 0
          ? Text('')
          : FloatingActionButton(
              onPressed: () {},
              backgroundColor: Defaults.greenPrincipal,
              foregroundColor: Colors.white,
            ),
      body: Container(
        decoration: BoxDecoration(color: Defaults.blueFondCadre),
        child: Column(
          children: [
            Padding(
              padding:
                  EdgeInsets.only(left: 20, right: 10, top: 15, bottom: 15),
              child:
                  // _countContract == 0
                  //     ? Text('')
                  // :
                  TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.search),
                  hintText: 'Pesquisa por cliente ou contrato',
                ),
                onChanged: (value) {
                  filterClients(value);
                },
              ),
            ),
            // if (_searchText
            //     .isNotEmpty) // Affiche les données uniquement si le champ de recherche n'est pas vide
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTileTheme(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const Divider(
                      color: Colors.white,
                    ),
                    itemCount: _contracts.length,
                    itemBuilder: (context, index) {
                      Contract contract = _contracts[index];
                      return Card(
                        elevation: 10,
                        margin: EdgeInsets.all(0.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${contract.clientName}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Defaults.bluePrincipal,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${contract.id}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Defaults.bluePrincipal,
                                ),
                              ),
                              Text(
                                '${contract.offer}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Defaults.bluePrincipal,
                                ),
                              ),
                            ],
                          ),
                          // trailing: contract.id == contract.offer
                          //     ? IconButton(
                          //         onPressed: () {},
                          //         icon: Icon(
                          //           Icons.print,
                          //           color: Defaults.greenPrincipal,
                          //         ),
                          //       )
                          //     : Text(''),
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PaymentPage(
                                  contract: _contracts[index],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
