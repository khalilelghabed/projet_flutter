// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'edit_stage.dart';
import 'home_page.dart';
import 'SqlDb.dart';
import 'objectifs.dart';
import 'realisations.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key, required this.idstage}) : super(key: key);
  final String idstage;

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late Future<List<Map>> _stageData;

  @override
  void initState() {
    super.initState();
    _stageData =
        SqlDb().readData('SELECT * FROM stage where id=?', [widget.idstage]);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color.fromARGB(255, 69, 98, 104),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.zero,
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
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            stage["titre"],
                            style: TextStyle(fontSize: 22, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Entreprise: ${stage["entreprise"]}",
                            style: TextStyle(fontSize: 14, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const Center(child: Text("No stages found."));
                }
              },
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  splashColor: Color.fromARGB(203, 69, 98, 104),
                  leading: const Icon(Icons.home, color: Colors.white),
                  title: const Text(' Accueil ',
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MyHomePage(idstage: widget.idstage)),
                    );
                  },
                ),
                ListTile(
                  splashColor: Color.fromARGB(90, 69, 98, 104),
                  leading: const Icon(Icons.receipt_long, color: Colors.white),
                  title: const Text(' Missions ',
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  splashColor: Color.fromARGB(203, 69, 98, 104),
                  leading: const Icon(Icons.format_list_numbered,
                      color: Colors.white),
                  title: const Text(' Objectifs ',
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Objectif(idstage: widget.idstage)),
                    );
                  },
                ),
                ListTile(
                  splashColor: Color.fromARGB(203, 69, 98, 104),
                  leading: const Icon(Icons.rule, color: Colors.white),
                  title: const Text(' Réalisations ',
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Realisations(idstage: widget.idstage)),
                    );
                  },
                ),
                ListTile(
                  splashColor: Color.fromARGB(90, 69, 98, 104),
                  leading: const Icon(Icons.edit, color: Colors.white),
                  title: const Text(' Modifier ',
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              EditStagePage(idstage: widget.idstage)),
                    );
                  },
                ),
                ListTile(
                  splashColor: Color.fromARGB(203, 69, 98, 104),
                  leading: const Icon(Icons.logout, color: Colors.white),
                  title: const Text(' Quitter ',
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.of(context)
                      ..pop()
                      ..pop();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
