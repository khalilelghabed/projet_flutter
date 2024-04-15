import 'package:flutter/material.dart';
import 'drawer.dart'; // Make sure this points to your custom drawer file
import 'SqlDb.dart';

class Realisations extends StatefulWidget {
  const Realisations({super.key, required this.idstage});
  final String idstage;

  @override
  State<Realisations> createState() => _RealisationsState();
}

class _RealisationsState extends State<Realisations> {
  late Future<List<Map>> _realisationsData;

  @override
  void initState() {
    super.initState();
    //_realisationsData = SqlDb().readData('SELECT * FROM mission where stageId=? etat=?', [widget.idstage,1]);
    _realisationsData =
        SqlDb().readData('SELECT * FROM mission where etat=?', [1]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Réalisations",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 69, 98, 104),
      ),
      drawer: CustomDrawer(
          idstage: widget.idstage), // Use the newly named CustomDrawer widget
      body: FutureBuilder(
        future: _realisationsData,
        builder: (BuildContext context, AsyncSnapshot<List<Map>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var realisation = snapshot.data![index];
                return Padding(
                  padding:
                      const EdgeInsets.only(right: 8.0, left: 8.0, top: 8.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.only(left: 16, right: 10),
                    title: Text(realisation['description'] ?? 'Aucun titre'),
                    subtitle: Text(
                        "${realisation["dateDebut"]} - ${realisation["dateFin"]}"),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    tileColor: const Color.fromARGB(210, 69, 98, 104),
                    textColor: Colors.white,
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("No réalisations found."));
          }
        },
      ),
    );
  }
}
