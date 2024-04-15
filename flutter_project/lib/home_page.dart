import 'package:flutter/material.dart';
import 'drawer.dart'; // Make sure this points to your custom drawer file
import 'SqlDb.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.idstage}) : super(key: key);
  final String idstage;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Map>> _stageData;

  @override
  void initState() {
    super.initState();
    _stageData =
        SqlDb().readData('SELECT * FROM stage where id=?', [widget.idstage]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Accueil",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 69, 98, 104),
      ),
      drawer: CustomDrawer(idstage: widget.idstage),
      body: FutureBuilder(
        future: _stageData,
        builder: (BuildContext context, AsyncSnapshot<List<Map>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            var stage = snapshot.data![0];

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      stage["titre"],
                      style: const TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Divider(
                    height: 20,
                    thickness: 0.5,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 20.0),
                  _buildInfoItem(
                    icon: Icons.person,
                    title: "Stagiaire:",
                    content: stage["stagaireNom"],
                  ),
                  const SizedBox(height: 20.0),
                  _buildInfoItem(
                    icon: Icons.email,
                    title: "Email:",
                    content: stage["stagaireEmail"],
                  ),
                  const SizedBox(height: 20.0),
                  _buildInfoItem(
                    icon: Icons.business,
                    title: "Entreprise:",
                    content: stage["entreprise"],
                  ),
                  const SizedBox(height: 20.0),
                  _buildInfoItem(
                    icon: Icons.description,
                    title: "Description:",
                    content: stage["description"],
                    isLarge: true,
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text("Rien."));
          }
        },
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String content,
    bool isLarge = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon),
              const SizedBox(width: 5.0),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 1.0),
          isLarge
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10.0),
                  height: 120.0, // Adjust the height as needed
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(content),
                )
              : Text(content),
        ],
      ),
    );
  }
}
