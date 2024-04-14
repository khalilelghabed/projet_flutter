import 'package:flutter/material.dart';
import 'drawer.dart'; // Make sure this points to your custom drawer file
import 'SqlDb.dart';

class MyHomePage extends StatefulWidget{
  const MyHomePage({super.key,required this.idstage});
  final String idstage;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Map>> _stageData;

  @override
  void initState() {
    super.initState();
    _stageData = SqlDb().readData('SELECT * FROM stage where id=?',[widget.idstage]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Center(
          child :Text(
            "Informations",
            style: TextStyle(color: Colors.white),
            )
          ),
        backgroundColor: const Color.fromARGB(255, 97, 25, 14),
      ),
      drawer: CustomDrawer(idstage:widget.idstage), // Use the newly named CustomDrawer widget
      body: FutureBuilder(
        future: _stageData,
        builder: (BuildContext context, AsyncSnapshot<List<Map>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            var stage = snapshot.data![0];
            return Text(stage["titre"]);



          } else {
            return const Center(child: Text("No stages found."));
          }
        },
      ),
    );
  }
}
