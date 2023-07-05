import 'package:appfres/_api/tokenStorageService.dart';
import 'package:appfres/di/service_locator.dart';
import 'package:appfres/models/agent.dart';
import 'package:appfres/ui/pages/login.page.dart';
import 'package:appfres/widgets/default.colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

var indexClicked = 0;

class _MyDrawerState extends State<MyDrawer> {
  final storage = locator<TokenStorageService>();
  late final Future<Agent?> _futureAgentConnected;

  @override
  void initState() {
    _futureAgentConnected = getAgent();
    super.initState();
  }

  Future<Agent?> getAgent() async {
    return await storage.retrieveAgentConnected();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                color: Defaults.bottomColor,
              ),
              padding:
                  const EdgeInsets.only(left: 0, top: 10, bottom: 0, right: 0),
              child: Container(
                child: Column(
                  children: [
                    Icon(Icons.account_circle_rounded,
                        size: 59, color: Colors.white),
                    const SizedBox(
                      height: 20,
                    ),
                    FutureBuilder<Agent?>(
                        future: _futureAgentConnected,
                        builder: (context, snapshot) {
                          return Column(
                            children: [
                              Text(
                                snapshot.hasData
                                    ? '${snapshot.data!.prenom} ${snapshot.data!.nom}'
                                    : '',
                                style: GoogleFonts.sanchez(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500,
                                  color: Defaults.libelleColor,
                                ),
                              ),
                              Text(
                                snapshot.hasData
                                    ? '${snapshot.data!.matricule}'
                                    : '',
                                style: GoogleFonts.sanchez(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ],
                          );
                        })
                  ],
                ),
              )),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: const [
                AppDrawerTile(
                  index: 0,
                  route: '/home',
                ),
                AppDrawerTile(
                  index: 1,
                  route: '/listerecensement',
                ),
                AppDrawerTile(
                  index: 2,
                  route: '/transfert',
                ),
                AppDrawerTile(
                  index: 3,
                  route: '',
                ),
              ],
            ),
          ),
          Divider(
            height: 10,
            color: Defaults.bluePrincipal,
            indent: 20,
            endIndent: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 0.0, right: 110.0, top: 30, bottom: 100),
            child: TextButton.icon(
              // <-- TextButton
              onPressed: () {
                storage.deleteAllToken();
                indexClicked = 0;
                Navigator.of(context).pop();
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => LoginPage()));
              },
              icon: Icon(
                Icons.power_settings_new_sharp,
                size: 30.0,
              ),
              label: Text(
                'Déconnexion',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 20.0, top: 40, bottom: 50),
            child: Image.asset(
              'images/img.png',
              height: 100,
              width: 75,
            ),
          )
        ],
      ),
    );
  }
}
//

class AppDrawerDivider extends StatelessWidget {
  const AppDrawerDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: Defaults.textColor,
      indent: 3,
      endIndent: 3,
    );
  }
}

class AppDrawerTile extends StatefulWidget {
  const AppDrawerTile({Key? key, required this.index, required this.route})
      : super(key: key);

  final int index;
  final String route;

  @override
  State<AppDrawerTile> createState() => _AppDrawerTileState();
}

class _AppDrawerTileState extends State<AppDrawerTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListTile(
        onTap: () {
          setState(() {
            indexClicked = widget.index;
          });
          Navigator.pop(context);
          Navigator.pushNamed(context, widget.route);
        },
        selected: indexClicked == widget.index,
        selectedTileColor: Defaults.drawerSelectedTileColor,
        leading: Icon(
          Defaults.drawerItemIcon[widget.index],
          size: 30,
          color: indexClicked == widget.index
              ? Defaults.drawerItemSelectedColor
              : Defaults.textColor,
        ),
        title: Text(
          Defaults.drawerItemText[widget.index],
          style: GoogleFonts.sanchez(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: indexClicked == widget.index
                ? Defaults.drawerItemSelectedColor
                : Defaults.textColor,
          ),
        ),
      ),
    );
  }
}
