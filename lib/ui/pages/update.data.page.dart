// ignore_for_file: prefer_const_constructors, use_build_context_synchronously
import 'package:appfres/_api/apiService.dart';
import 'package:appfres/db/local.service.dart';
import 'package:appfres/di/service_locator.dart';
import 'package:appfres/models/dto/customer.dart';
import 'package:appfres/models/user.dart';
import 'package:appfres/ui/pages/home.page.dart';
import 'package:appfres/widgets/default.colors.dart';
import 'package:appfres/widgets/loading.indicator.dart';
import 'package:appfres/widgets/mydrawer.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class UpdateDataPage extends StatefulWidget {
  const UpdateDataPage({Key? key}) : super(key: key);

  @override
  State<UpdateDataPage> createState() => _UpdateDataPageState();
}

class _UpdateDataPageState extends State<UpdateDataPage> {
  final dbHandler = locator<LocalService>();
  User? agentConnected;
  final apiService = locator<ApiService>();

  @override
  void initState() {
    // _futureEncaissement = getAllEncaissement();
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   // do something
    //   getAllEncaissement().then((value) => {
    //         setState(() {
    //           _countEncaissement = value.length;
    //           _Payments = value;
    //         })
    //       });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Defaults.appBarColor,
        title: const Text('Mise à jour de donnée'),
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
                            "Mise à jour des données",
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
                            // child: FutureBuilder(
                            //     future: _futureEncaissement,
                            //     builder: (context, snapshot) {
                            //       return Text(
                            //           snapshot.hasData
                            //               ? snapshot.data!.length.toString()
                            //               : '0',
                            //           style: const TextStyle(fontSize: 75));
                            //     }),
                          ),
                          const SizedBox(
                            height: 13,
                          ),
                          SizedBox(
                              width: 250,
                              child: ElevatedButton(
                                  onPressed: () => _submitLogin(),
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
                                          'Dowloand',
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

  Future<void> _submitLogin() async {
    LoadingIndicatorDialog().show(context);
    var statusCode = await apiService.getAllClients();
    if (statusCode == 200) {
      //load customer
      List<Customer> customers = await apiService.getAllClients();
      for (var customer in customers) {
        dbHandler.SaveCustomer(customer);
        for (var contract in customer.contracts) {
          contract.client_id = customer.reference.toString();
          dbHandler.SaveContract(contract);
        }
      }
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            'SUCCESS',
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
                  'Updating was Successfull',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const HomePage()));
                },
                child: const Text('GO BACK'))
          ],
        ),
      );
    } else {
      LoadingIndicatorDialog().dismiss();
      return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                'ERROR',
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
                      'Error in Acknowledging',
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
                    child: const Text('Réessayer'))
              ],
            );
          });
    }
  }
}
