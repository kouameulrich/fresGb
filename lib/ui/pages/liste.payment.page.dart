// ignore_for_file: prefer_const_constructors, unused_field, unnecessary_string_interpolations

import 'package:appfres/_api/tokenStorageService.dart';
import 'package:appfres/db/local.service.dart';
import 'package:appfres/di/service_locator.dart';
import 'package:appfres/misc/printer.service.dart';
import 'package:appfres/models/dto/customer.dart';
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
  final _formKey = GlobalKey<FormState>();
  final dbHandler = locator<LocalService>();
  final storage = locator<TokenStorageService>();
  late final Future<User?> _futureAgentConnected;
  User? agentConnected;

  //------ client declaration ------
  Customer? customer;
  List<Customer> _customers = [];
  int _countCustomer = 0;
  int _countCustomerPay = 0;

  TextEditingController searchController = TextEditingController();

  Future<User?> getAgent() async {
    return await storage.retrieveAgentConnected();
  }

  Future<List<Customer>> getAllClient() async {
    return await dbHandler.readAllClient();
  }

  String _searchText = ''; // Variable pour stocker le texte de recherche

  void filterClients(String searchText) {
    setState(() {
      _searchText = searchText; // Met à jour le texte de recherche
      _customers = _customers
          .where((element) =>
              element.phoneNumber!.contains(searchText) ||
              element.firstName!
                  .toLowerCase()
                  .contains(searchText.toString().toLowerCase()) ||
              element.lastName!
                  .toLowerCase()
                  .contains(searchText.toString().toLowerCase()) ||
              element.reference!
                  .toString()
                  .toLowerCase()
                  .contains(searchText.toLowerCase()))
          .toList();
      _countCustomer = _customers.length;
    });
  }

  @override
  void initState() {
    _futureAgentConnected = getAgent();
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      print('------- DATA -------');

      getAllClient().then((value) => setState(() {
            _countCustomer = value.length;
            _customers = value;
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
            const Text('Encaissement'),
            Text(
              '$_countCustomerPay/$_countCustomer',
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
        centerTitle: true,
      ),
      drawer: MyDrawer(),
      floatingActionButton: _countCustomerPay == 0
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
              child: _countCustomer == 0
                  ? Text('')
                  : TextFormField(
                      controller: searchController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.search),
                        hintText: 'Recherche par client ou contrat',
                      ),
                      onChanged: (value) {
                        filterClients(value);
                      },
                    ),
            ),
            if (_searchText
                .isNotEmpty) // Affiche les données uniquement si le champ de recherche n'est pas vide
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
                      itemCount: _customers.length,
                      itemBuilder: (context, index) {
                        Customer customer = _customers[index];
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
                                  '${customer.firstName} ${customer.lastName}',
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
                                  '${customer.village} - ${customer.reference}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Defaults.bluePrincipal,
                                  ),
                                ),
                                Text(
                                  '${customer.phoneNumber}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Defaults.bluePrincipal,
                                  ),
                                ),
                                Text(
                                  '${customer.contracts}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Defaults.bluePrincipal,
                                  ),
                                ),
                              ],
                            ),
                            // trailing: contract.offer == contract.offer
                            //     ?
                            trailing: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.print,
                                color: Defaults.greenPrincipal,
                              ),
                            ),
                            // : Text(''),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => PaymentPage(
                                            customer: _customers![index],
                                          )));
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
