// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'edit_stage.dart';
import 'home_page.dart';
import 'SqlDb.dart';
import 'realisations.dart';
import 'afficher_missions.dart';
class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key, required this.idstage});
  final String idstage;

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late Future<List<Map>> _stageData;

  @override
  void initState() {
    super.initState();
    _stageData = SqlDb().readData('SELECT * FROM stage where id=?', [widget.idstage]);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          SizedBox(
            height: 138,
            child: FutureBuilder(
              future: _stageData,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Map>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  var stage = snapshot.data![0];

                  return DrawerHeader(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 97, 25, 14),
                    ),
                    child: UserAccountsDrawerHeader(
                      //margin: EdgeInsets.all(0),
                      decoration: BoxDecoration(color: Color.fromARGB(255, 97, 25, 14)),
                      accountName: Text(
                        stage["titre"],
                        style: TextStyle(fontSize: 18),
                      ),
                      accountEmail: Text(stage["entreprise"]),
                    ),
                  );



                } else {
                  return const Center(child: Text("No stages found."));
                }
              },
            ),
          ),
          ListTile(
            splashColor: Colors.redAccent[100],
            leading: const Icon(Icons.info),
            title: const Text(' Informations '),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => MyHomePage(idstage: widget.idstage)),
              );
            },
          ),
          ListTile(
            splashColor: Colors.redAccent[100],
            leading: const Icon(Icons.receipt_long),
            title: const Text(' Missions '),
            onTap: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AfficherMissionsPage(idStage: widget.idstage)),
              );
            },
          ),
          ListTile(
            splashColor: Colors.redAccent[100],
            leading: const Icon(Icons.task),
            title: const Text(' Objectifs '),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            splashColor: Colors.redAccent[100],
            leading: const Icon(Icons.rule),
            title: const Text(' Réalisations '),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => Realisations(idstage: widget.idstage)),
              );
            },
          ),
          ListTile(
            splashColor: Colors.redAccent[100],
            leading: const Icon(Icons.edit),
            title: const Text(' Modifier '),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => EditStagePage(idstage: widget.idstage)),
              );
            },
          ),
          ListTile(
            splashColor: Colors.redAccent[100],
            leading: const Icon(Icons.logout),
            title: const Text(' Quitter '),
            onTap: () {
              Navigator.of(context)..pop()..pop();
            },
          ),
        ],
      ),
    );
  }
}
