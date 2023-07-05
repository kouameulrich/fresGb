// ignore_for_file: non_constant_identifier_names, must_be_immutable

import 'dart:math';

import 'package:appfres/_api/apiService.dart';
import 'package:appfres/_api/tokenStorageService.dart';
import 'package:appfres/db/local.service.dart';
import 'package:appfres/di/service_locator.dart';
import 'package:appfres/models/agent.dart';
import 'package:appfres/models/encaissement.dart';
import 'package:appfres/models/sexeContribuable.dart';
import 'package:appfres/ui/pages/liste.encaissement.page.dart';
import 'package:appfres/widgets/default.colors.dart';
import 'package:appfres/widgets/loading.indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class EncaissementPage extends StatefulWidget {
  EncaissementPage({Key? key}) : super(key: key);

  // final Encaissement Encaissement;

  @override
  State<EncaissementPage> createState() => _EncaissementPageState();
}

class _EncaissementPageState extends State<EncaissementPage> {
  TextEditingController dateEncaissementController = TextEditingController();
  TextEditingController nomClientController = TextEditingController();
  TextEditingController prenomClientController = TextEditingController();
  TextEditingController sexeClientController = TextEditingController();
  TextEditingController numeroCompteurController = TextEditingController();
  TextEditingController montantClientController = TextEditingController();
  TextEditingController telephoneClientController = TextEditingController();
  TextEditingController matriculeAgentController = TextEditingController();

  final docPage = pw.Document();
  final _formKey = GlobalKey<FormState>();
  final apiService = locator<ApiService>();
  final dbHandler = locator<LocalService>();
  final _storage = locator<TokenStorageService>();

  String? matricule;
  String? sexeContribuable;

  List<SexeContribuable> sexeContribuables = [
    SexeContribuable("Particulier", "M"),
    SexeContribuable("Entreprise", "F")
  ];

  @override
  void initState() {
    print('inistate');
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('postconstrust');
      getAgentConnected().then((value) => setState(() {
            matricule = value!.matricule;
          }));
    });
  }

  @override
  void dispose() {
    dateEncaissementController.dispose();
    matriculeAgentController.dispose();
    nomClientController.dispose();
    prenomClientController.dispose();
    sexeClientController.dispose();
    montantClientController.dispose();
    telephoneClientController.dispose();
    numeroCompteurController.dispose();
    super.dispose();
  }

  Future<Agent?> getAgentConnected() async {
    return await _storage.retrieveAgentConnected();
  }

  @override
  Widget build(BuildContext context) {
    print('build widget');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Defaults.appBarColor,
        //automaticallyImplyLeading: false,
        title: const Text('Ajouter un encaissement'),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => ListeEncaissementPage()));
            },
            icon: Icon(Icons.arrow_back_ios_new)),
      ),
      //drawer: MyDrawer(),
      body: Container(
        decoration: const BoxDecoration(color: Defaults.blueFondCadre),
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      //------------------ NOM ---------------
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 55,
                          padding: const EdgeInsets.only(top: 3, left: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: nomClientController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nom Client';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: null,
                                  icon: Icon(Icons.list_rounded)),
                              border: InputBorder.none,
                              hintText: 'Nom Client',
                            ),
                          ),
                        ),
                      ),

                      //--------PRENOM-------------
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 55,
                          padding: const EdgeInsets.only(top: 3, left: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: prenomClientController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Prenoms Client';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: null,
                                  icon: Icon(Icons.list_rounded)),
                              border: InputBorder.none,
                              hintText: 'Prenoms Client',
                            ),
                          ),
                        ),
                      ),

                      //----------------- SEXE ---------------
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 55,
                          padding: const EdgeInsets.only(top: 3, left: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              hint: const Text("Selectionnez un genre"),
                              isExpanded: true,
                              value: sexeContribuable,
                              onSaved: (newValue) =>
                                  sexeContribuable = newValue,
                              onChanged: (newValue) {
                                setState(() {
                                  sexeContribuable = newValue;
                                });
                              },
                              items: sexeContribuables
                                  .map((fc) => DropdownMenuItem<String>(
                                        value: fc.label,
                                        child: Text(
                                          fc.label.toString(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ))
                                  .toList()),
                        ),
                      ),

                      //-------------- NUMERO COMPTEUR -------------
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 55,
                          padding: const EdgeInsets.only(top: 3, left: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: numeroCompteurController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Numero Compteur';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: null,
                                  icon: Icon(Icons.list_rounded)),
                              border: InputBorder.none,
                              hintText: 'Numero Compteur',
                            ),
                          ),
                        ),
                      ),

                      //---------------- MONTANT --------------
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 55,
                          padding: const EdgeInsets.only(top: 3, left: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: montantClientController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Entrer un montant';
                              } else if (double.parse(value) < 100) {
                                return 'Entrer un montant superieur ou égal à 100';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: null,
                                  icon: Icon(Icons.list_rounded)),
                              border: InputBorder.none,
                              hintText: 'Entrer Montant',
                            ),
                          ),
                        ),
                      ),

                      /////-------------- TELEPHNONE -------------
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 55,
                          padding: const EdgeInsets.only(top: 3, left: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: telephoneClientController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Contact Client';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: null,
                                  icon: Icon(Icons.list_rounded)),
                              border: InputBorder.none,
                              hintText: 'Contact Client',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Defaults.bottomColor,
        onPressed: _submitDetails,
        child: const Icon(Icons.save),
      ),
    );
  }

  void showSnackBarMessage(String message, [MaterialColor color = Colors.red]) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _submitDetails() {
    final FormState? formState = _formKey.currentState;
    DateFormat dateFormat = DateFormat("dd/MM/yyyy");
    Encaissement encaissement = Encaissement(
        nomClient: nomClientController.text,
        prenomClient: prenomClientController.text,
        sexeClient: sexeContribuable,
        numeroCompteur: numeroCompteurController.text,
        montantClient: double.parse(montantClientController.text.toString()),
        telephoneClient: telephoneClientController.text,
        dateEncaissement: dateFormat.format(DateTime.now()),
        id: Random().nextInt(50),
        matriculeAgent: matricule);
    if (!formState!.validate()) {
      showSnackBarMessage('Renseigner les champs obligatoires');
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirmation",
                  style: TextStyle(
                    color: Color.fromRGBO(15, 81, 105, 1),
                  )),
              content: Container(
                  child: Column(
                //mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Infos Générale',
                      style: TextStyle(
                          color: Color.fromRGBO(20, 201, 166, 1),
                          fontSize: 20)),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Nom:  ${encaissement.nomClient}'),
                      SizedBox(
                        height: 4,
                      ),
                      Text('Prenom: ${encaissement.prenomClient}'),
                      SizedBox(
                        height: 4,
                      ),
                      Text('Genre:  ${encaissement.sexeClient}'),
                      SizedBox(
                        height: 4,
                      ),
                      Text('Telephone:  ${encaissement.telephoneClient}'),
                      SizedBox(
                        height: 4,
                      ),
                      Text('Numero Compteur:  ${encaissement.numeroCompteur}'),
                      SizedBox(
                        height: 4,
                      ),
                      Text('Montant:  ${encaissement.montantClient}'),
                    ],
                  ),
                ],
              )),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Annuler',
                      style: TextStyle(color: Color.fromRGBO(15, 81, 105, 1)),
                    )),
                TextButton(
                  child: const Text(
                    'Ajouter',
                    style: TextStyle(color: Color.fromRGBO(20, 201, 166, 1)),
                  ),
                  onPressed: () {
                    LoadingIndicatorDialog().show(context);
                    dbHandler.SaveEncaissement(encaissement);
                    LoadingIndicatorDialog().dismiss();
                    void printerPage() async {
                      final logoImage = pw.MemoryImage(
                          (await rootBundle.load('images/img.png'))
                              .buffer
                              .asUint8List());
                      docPage.addPage(
                        pw.Page(
                          pageFormat: PdfPageFormat.a6,
                          build: (pw.Context context) => pw.Column(
                            children: [
                              pw.Divider(),
                              pw.Text('INFORMATION CLIENT',
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 15)),
                              pw.Divider(),
                              pw.SizedBox(
                                height: 5,
                              ),
                              pw.Text('Réçu Client',
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 15)),
                              pw.SizedBox(
                                height: 10,
                              ),
                              pw.Text(
                                  'CLIENT: ${encaissement.nomClient} ${encaissement.prenomClient}',
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.normal,
                                      fontSize: 12)),
                              pw.SizedBox(
                                height: 10,
                              ),
                              pw.Text(
                                  'NUMERO COMPTEUR: ${encaissement.numeroCompteur}',
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.normal,
                                      fontSize: 12)),
                              pw.SizedBox(
                                height: 10,
                              ),
                              pw.Text('${encaissement.montantClient}',
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 25)),
                              pw.Text(
                                  'NUMERO CLIENT: ${encaissement.telephoneClient}',
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.normal,
                                      fontSize: 12)),
                              // pw.Text(
                              //     'Opérateur : ${agentConnected!.nom} ${agentConnected!.prenom}'),
                              pw.SizedBox(
                                height: 50,
                              ),
                              pw.Image(
                                alignment: pw.Alignment.center,
                                height: 75,
                                width: 75,
                                logoImage,
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    printerPage();
                    // Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PreviewScreen(docPage: docPage),
                        ));
                  },
                ),
              ],
            );
          });
    }
  }
}

class PreviewScreen extends StatelessWidget {
  pw.Document docPage;
  PreviewScreen({Key? key, required this.docPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ListeEncaissementPage(),
              )),
        ),
        centerTitle: true,
        title: Text('Preview Page'),
      ),
      body: PdfPreview(
        build: (format) => docPage.save(),
        allowPrinting: true,
        allowSharing: true,
        initialPageFormat: PdfPageFormat.a6,
        pdfFileName: 'Recu.pdf',
      ),
    );
  }
}
