import 'package:appfres/_api/apiService.dart';
import 'package:appfres/_api/tokenStorageService.dart';
import 'package:appfres/db/local.service.dart';
import 'package:appfres/di/service_locator.dart';
import 'package:appfres/models/agent.dart';
import 'package:appfres/models/encaissement.dart';
import 'package:appfres/ui/pages/encaissement.page.dart';
import 'package:appfres/widgets/default.colors.dart';
import 'package:appfres/widgets/mydrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ListeEncaissementPage extends StatefulWidget {
  const ListeEncaissementPage({Key? key}) : super(key: key);

  @override
  State<ListeEncaissementPage> createState() => _ListeEncaissementPageState();
}

class _ListeEncaissementPageState extends State<ListeEncaissementPage> {
  TextEditingController searchController = TextEditingController();

  Future<List<Encaissement>>? _futureEncaissement;
  final apiService = locator<ApiService>();
  // final printerService = locator<PrinterService>();
  final dbHandler = locator<LocalService>();
  final storage = locator<TokenStorageService>();
  Agent? agentConnected;
  Encaissement? encaissement;
  int _countEncaissement = 0;
  List<Encaissement> _Encaissements = [];

  Future<List<Encaissement>> getAllEncaissement() async {
    return await dbHandler.readAllEncaissement();
  }

  Future<void> updateEncaissement() async {
    return await dbHandler.UpdateEncaissement(Encaissement());
  }

  @override
  void initState() {
    _futureEncaissement = getAllEncaissement();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // do something
      getAllEncaissement().then((value) => setState(() {
            _countEncaissement = value.length;
          }));
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Defaults.appBarColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Encaissements'),
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    //color: Colors.white,
                  ),
                  child: Text(
                    '($_countEncaissement)',
                    style: const TextStyle(color: Colors.green),
                  )),
            ],
          ),
          centerTitle: true,
        ),
        drawer: MyDrawer(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Defaults.bottomColor,
          foregroundColor: Colors.white,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => EncaissementPage()));
          },
          child: const Icon(Icons.add),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 10, top: 15, bottom: 15),
              child: _countEncaissement == 0
                  ? const Text('')
                  : TextFormField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.search),
                        hintText: 'Recherche',
                      ),
                      onChanged: (value) {
                        setState(() {
                          getAllEncaissement().then((Encaissements) => {
                                _Encaissements = Encaissements.where(
                                    (element) =>
                                        element.telephoneClient!.contains(
                                            searchController.text.toString()) ||
                                        element.nomClient!
                                            .toLowerCase()
                                            .contains(searchController.text
                                                .toString()
                                                .toLowerCase()) ||
                                        element.prenomClient!
                                            .toLowerCase()
                                            .contains(searchController.text
                                                .toString()
                                                .toLowerCase()) ||
                                        element.numeroCompteur!
                                            .toLowerCase()
                                            .contains(searchController.text
                                                .toString()
                                                .toLowerCase())).toList(),
                                _countEncaissement = _Encaissements.length
                              });
                        });
                      },
                    ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTileTheme(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: FutureBuilder(
                      future: _futureEncaissement,
                      builder: (context, snapshot) {
                        return ListView.separated(
                          itemCount:
                              snapshot.data == null ? 0 : snapshot.data!.length,
                          separatorBuilder: (context, index) => const Divider(
                            color: Colors.white,
                          ),
                          itemBuilder: (context, index) {
                            return Card(
                              color: Colors.white,
                              elevation: 5.0,
                              margin: const EdgeInsets.all(0),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: const CircleAvatar(
                                      backgroundColor:
                                          Color.fromRGBO(15, 81, 105, 1),
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      ),
                                    ),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            '${snapshot.data![index].nomClient} ${snapshot.data![index].prenomClient}'),
                                        Text(
                                            '${NumberFormat.currency(decimalDigits: 0, name: '').format(snapshot.data![index].montantClient)} - ${snapshot.data![index].telephoneClient}'),
                                      ],
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        /////------------- CODE POUR DELETE ENCAISSEMENT ----------/////

                                        // IconButton(
                                        //     onPressed: () {
                                        //       showDialog(
                                        //           context: context,
                                        //           builder: (context) {
                                        //             return AlertDialog(
                                        //               title: const Text(
                                        //                   'Confirmation'),
                                        //               content: const Text(
                                        //                   'Voulez-vous supprimer ce Encaissement?'),
                                        //               actions: [
                                        //                 TextButton(
                                        //                     child: const Text(
                                        //                         'Non'),
                                        //                     onPressed: () {
                                        //                       Navigator.of(
                                        //                               context)
                                        //                           .pop();
                                        //                     }),
                                        //                 TextButton(
                                        //                     onPressed: () {
                                        //                       //LoadingIndicatorDialog().show(context);
                                        //                       dbHandler.deleteEncaissement(
                                        //                           snapshot
                                        //                               .data![
                                        //                                   index]
                                        //                               .id);
                                        //                       _futureEncaissement =
                                        //                           getAllEncaissement();
                                        //                       getAllEncaissement()
                                        //                           .then(
                                        //                               (value) =>
                                        //                                   {
                                        //                                     setState(() {
                                        //                                       _futureEncaissement;
                                        //                                       _countEncaissement = value.length;
                                        //                                     })
                                        //                                   });
                                        //                       //LoadingIndicatorDialog().dismiss();
                                        //                       Navigator.of(
                                        //                               context)
                                        //                           .pop();
                                        //                     },
                                        //                     child: const Text(
                                        //                         'Oui'))
                                        //               ],
                                        //             );
                                        //           });
                                        //     },
                                        //     icon: const Icon(
                                        //       Icons.delete,
                                        //       color: Colors.red,
                                        //     )),
                                        IconButton(
                                            onPressed: () async {
                                              await storage
                                                  .retrieveAgentConnected()
                                                  .then((value) =>
                                                      agentConnected = value);
                                              await dbHandler
                                                  .UpdateEncaissement(
                                                      Encaissement());
                                              // pw.Document  docPage1 = await printerService.printEncaissement(agentConnected!, Encaissement!);
                                              // Navigator.push(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //       builder: (context) =>
                                              //           PrintingPage(docPage: docPage1),
                                              //     ));
                                            },
                                            icon: const Icon(
                                              Icons.print,
                                              color: Defaults.greenPrincipal,
                                            ))
                                      ],
                                    ),
                                    subtitle: Text(
                                        '${snapshot.data![index].dateEncaissement}'),
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text("Confirmation",
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        15, 81, 105, 1),
                                                  )),
                                              content: Column(
                                                //mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text('Infos Générale',
                                                      style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              20, 201, 166, 1),
                                                          fontSize: 20)),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                          'Nom:  ${snapshot.data![index].nomClient}'),
                                                      SizedBox(
                                                        height: 4,
                                                      ),
                                                      Text(
                                                          'Prenom: ${snapshot.data![index].prenomClient}'),
                                                      SizedBox(
                                                        height: 4,
                                                      ),
                                                      Text(
                                                          'Genre:  ${snapshot.data![index].sexeClient}'),
                                                      SizedBox(
                                                        height: 4,
                                                      ),
                                                      Text(
                                                          'Telephone:  ${snapshot.data![index].telephoneClient}'),
                                                      SizedBox(
                                                        height: 4,
                                                      ),
                                                      Text(
                                                          'Numero Compteur:  ${snapshot.data![index].numeroCompteur}'),
                                                      SizedBox(
                                                        height: 4,
                                                      ),
                                                      Text(
                                                          'Montant:  ${snapshot.data![index].montantClient}'),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text('OK')),
                                                TextButton(
                                                    onPressed: () async {
                                                      // Navigator.push(
                                                      //     context,
                                                      //     MaterialPageRoute( builder: (_) => EncaissementPage(Encaissement: _Encaissements[index])));
                                                    },
                                                    child:
                                                        const Text('Modifier'))
                                              ],
                                            );
                                          });
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }),
                ),
              ),
            ),
          ],
        ));
  }
}
