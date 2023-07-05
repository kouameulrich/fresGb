// ignore_for_file: unused_field

import 'package:appfres/_api/apiService.dart';
import 'package:appfres/_api/tokenStorageService.dart';
import 'package:appfres/db/local.service.dart';
import 'package:appfres/di/service_locator.dart';
import 'package:appfres/models/agent.dart';
import 'package:appfres/models/encaissement.dart';
import 'package:appfres/widgets/default.colors.dart';
import 'package:appfres/widgets/mydrawer.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Encaissement>>? _futureEncaissement;
  final dbHandler = locator<LocalService>();
  final apiService = locator<ApiService>();

  Future<List<Encaissement>> getAllEncaissement() async {
    return await dbHandler.readAllEncaissement();
  }

  final storage = locator<TokenStorageService>();
  late final Future<Agent?> _futureAgentConnected;
  late TabController _tabController;
  int _countEquipementRecense = 0;

  List<Encaissement> _Encaissement = [];
  int maleNumber = 0;
  int femaleNumber = 0;
  int _countEncaissement = 0;
  double _montantRecense = 0.0;
  bool hasInternet = false;

  @override
  void initState() {
    _futureAgentConnected = getAgent();
    // _tabController = TabController(vsync: this, length: 2);

    //CHECKING CONNECTION
    InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;
      setState(() {
        this.hasInternet = hasInternet;
      });

      final color = hasInternet ? Colors.green : Colors.red;
      final text = hasInternet ? 'Connexion internet active' : 'Pas Internet';
      showSimpleNotification(
        Text(
          '$text',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        background: color,
      );
    });

    //Equipement recense
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAllEncaissement().then((value) => setState(() {
            _Encaissement = value;
            maleNumber = value
                .where((element) => element.sexeClient == 'Masculin')
                .toList()
                .length;
            femaleNumber = value
                .where((element) => element.sexeClient == 'Feminin')
                .toList()
                .length;
            _countEncaissement = _Encaissement.length;
            _montantRecense = value.fold(0,
                (value, element) => value.toDouble() + element.montantClient!);
          }));
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<Agent?> getAgent() async {
    return await storage.retrieveAgentConnected();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        backgroundColor: Defaults.blueFondCadre,
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(15, 81, 105, 1),
          title: const Text('Accueil'),
          bottom: const TabBar(
            indicatorColor: Defaults.greenSelected,
            //indicatorWeight: 5,
            tabs: [
              Tab(icon: Icon(Icons.list), text: 'Encaissement'),
            ],
          ),
        ),
        drawer: MyDrawer(),
        body: TabBarView(
          children: [
            GridView.count(
              padding: const EdgeInsets.all(5),
              crossAxisSpacing: 10,
              crossAxisCount: 2,
              children: [
                ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(
                                5.0,
                                5.0,
                              ), //Offset
                              blurRadius: 5.0,
                              spreadRadius: 2.0,
                            ), //BoxShadow
                            BoxShadow(
                              color: Colors.white,
                              offset: Offset(0.0, 0.0),
                              blurRadius: 0.0,
                              spreadRadius: 0.0,
                            ), //BoxShadow
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$_countEncaissement',
                                style: const TextStyle(
                                    fontSize: 24,
                                    color: Defaults.bluePrincipal,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'Encaissement',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Defaults.bluePrincipal),
                              ),
                              const Text(
                                'totale',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Defaults.bluePrincipal),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(
                                5.0,
                                5.0,
                              ), //Offset
                              blurRadius: 5.0,
                              spreadRadius: 2.0,
                            ), //BoxShadow
                            BoxShadow(
                              color: Colors.white,
                              offset: Offset(0.0, 0.0),
                              blurRadius: 0.0,
                              spreadRadius: 0.0,
                            ), //BoxShadow
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                NumberFormat.currency(
                                        decimalDigits: 0, name: '')
                                    .format(_montantRecense),
                                style: const TextStyle(
                                    fontSize: 24,
                                    color: Defaults.bluePrincipal,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'Montant',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Defaults.bluePrincipal),
                              ),
                              const Text(
                                'totale collecté',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Defaults.bluePrincipal),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(
                                5.0,
                                5.0,
                              ), //Offset
                              blurRadius: 5.0,
                              spreadRadius: 2.0,
                            ), //BoxShadow
                            BoxShadow(
                              color: Colors.white,
                              offset: Offset(0.0, 0.0),
                              blurRadius: 0.0,
                              spreadRadius: 0.0,
                            ), //BoxShadow
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$femaleNumber',
                                style: const TextStyle(
                                    fontSize: 24,
                                    color: Defaults.bluePrincipal,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'Client',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Defaults.bluePrincipal),
                              ),
                              const Text(
                                'Particulier',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Defaults.bluePrincipal),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(
                                5.0,
                                5.0,
                              ), //Offset
                              blurRadius: 5.0,
                              spreadRadius: 2.0,
                            ), //BoxShadow
                            BoxShadow(
                              color: Colors.white,
                              offset: Offset(0.0, 0.0),
                              blurRadius: 0.0,
                              spreadRadius: 0.0,
                            ), //BoxShadow
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$maleNumber',
                                style: const TextStyle(
                                    fontSize: 24,
                                    color: Defaults.bluePrincipal,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'Client',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Defaults.bluePrincipal),
                              ),
                              const Text(
                                'Entreprise',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Defaults.bluePrincipal),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
