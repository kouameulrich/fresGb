import 'package:appfres/_api/apiService.dart';
import 'package:appfres/db/local.service.dart';
import 'package:appfres/di/service_locator.dart';
import 'package:appfres/models/encaissement.dart';
import 'package:appfres/widgets/default.colors.dart';
import 'package:appfres/widgets/error.dialog.dart';
import 'package:appfres/widgets/loading.indicator.dart';
import 'package:appfres/widgets/mydrawer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class TransfertDonnees extends StatefulWidget {
  const TransfertDonnees({Key? key}) : super(key: key);

  @override
  State<TransfertDonnees> createState() => _TransfertDonneesState();
}

class _TransfertDonneesState extends State<TransfertDonnees> {
  Future<List<Encaissement>>? _futureEncaissement;
  final dbHandler = locator<LocalService>();
  final apiService = locator<ApiService>();
  int _countEncaissement = 0;
  List<Encaissement> _Encaissements = [];

  Future<List<Encaissement>> getAllEncaissement() async {
    return await dbHandler.readAllEncaissement();
  }

  @override
  void initState() {
    _futureEncaissement = getAllEncaissement();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // do something
      getAllEncaissement().then((value) => {
            setState(() {
              _countEncaissement = value.length;
              _Encaissements = value;
            })
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Defaults.appBarColor,
        title: const Text('Transfert'),
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
                    height: 250,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Text(
                            "Encaissements",
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              // color: Defaults.appBarColor,
                            ),
                            child: FutureBuilder(
                                future: _futureEncaissement,
                                builder: (context, snapshot) {
                                  return Text(
                                      snapshot.hasData
                                          ? snapshot.data!.length.toString()
                                          : '0',
                                      style: const TextStyle(fontSize: 75));
                                }),
                          ),
                          const SizedBox(
                            height: 13,
                          ),
                          SizedBox(
                              width: 250,
                              child: ElevatedButton(
                                  onPressed: () =>
                                      _transferEncaissementsToServer(),
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Defaults.bottomColor)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.send),
                                        Text(
                                          'Transferer',
                                          style: TextStyle(fontSize: 20),
                                        )
                                      ],
                                    ),
                                  ))),
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

  _transferEncaissementsToServer() {
    if (_countEncaissement > 0) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Confirmation'),
              content: const Text(
                  'Voulez-vous transferer les données vers le serveur?'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Non')),
                TextButton(
                    onPressed: () async {
                      try {
                        Navigator.of(context).pop();
                        LoadingIndicatorDialog().show(context);
                        //await  apiService.sendEncaissement(_Encaissements);
                        //delete local data after transfering
                        for (var Encaissement in _Encaissements) {
                          dbHandler.deleteEncaissement(Encaissement.id);
                        }
                        _futureEncaissement = getAllEncaissement();
                        setState(() {
                          _futureEncaissement;
                        });
                        LoadingIndicatorDialog().dismiss();
                      } on DioError catch (e) {
                        LoadingIndicatorDialog().dismiss();
                        ErrorDialog().show(e);
                        //print(e.message);
                      }
                    },
                    child: const Text('Oui'))
              ],
            );
          });
    }
  }
}
