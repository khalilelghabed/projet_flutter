import 'package:flutter/material.dart';
import 'SqlDb.dart';
import 'drawer.dart';
import 'home_page.dart'; // Ensure this is pointing to your SqlDb class correctly
import 'dart:typed_data';

class EditStagePage extends StatefulWidget {
  const EditStagePage({Key? key, required this.idstage}) : super(key: key);
  final String idstage;

  @override
  State<EditStagePage> createState() => _EditStagePageState();
}

class _EditStagePageState extends State<EditStagePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController stagiaireNomController = TextEditingController();
  TextEditingController stagiaireEmailController = TextEditingController();
  TextEditingController entrepriseController = TextEditingController();

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
          "Modifier",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 69, 98, 104),
      ),
      drawer: CustomDrawer(idstage: widget.idstage),
      body: Form(
        key: _formKey,
        child: FutureBuilder(
          future: _stageData,
          builder: (BuildContext context, AsyncSnapshot<List<Map>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              var stage = snapshot.data![0];
              titleController = TextEditingController(text: stage["titre"]);
              descriptionController =
                  TextEditingController(text: stage["description"]);
              startDateController =
                  TextEditingController(text: stage["dateDebut"]);
              endDateController = TextEditingController(text: stage["dateFin"]);
              stagiaireNomController =
                  TextEditingController(text: stage["stagaireNom"]);
              stagiaireEmailController =
                  TextEditingController(text: stage["stagaireEmail"]);
              entrepriseController =
                  TextEditingController(text: stage["entreprise"]);

              return ListView(
                padding: EdgeInsets.all(16),
                children: <Widget>[
                  SizedBox(height: 20),
                  // Section for Stage Information
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informations sur le Stage',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 69, 98, 104)),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: titleController,
                        decoration: InputDecoration(labelText: 'Titre'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un titre';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: entrepriseController,
                        decoration: InputDecoration(labelText: 'Entreprise'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer le nom de l\'entreprise';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: descriptionController,
                        decoration: InputDecoration(labelText: 'Description'),
                      ),
                      TextFormField(
                        controller: startDateController,
                        decoration: InputDecoration(labelText: 'Date de début'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer la date de début';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: endDateController,
                        decoration: InputDecoration(labelText: 'Date de fin'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer la date de fin';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informations sur le Stagiaire',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 69, 98, 104)),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: stagiaireNomController,
                        decoration: InputDecoration(labelText: 'Nom complet'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer le nom complet du stagiaire';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: stagiaireEmailController,
                        decoration:
                            InputDecoration(labelText: 'Email du stagiaire'),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _editStage,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 69, 98, 104),
                      ),
                      foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.white,
                      ),
                    ),
                    child: Text('sauvegarder'),
                  ),
                ],
              );
            } else {
              return const Center(child: Text("No stages found."));
            }
          },
        ),
      ),
    );
  }

  Future<void> _editStage() async {
    if (_formKey.currentState!.validate()) {
      final db = SqlDb();
      await db.updateData('''
        UPDATE stage 
        SET titre = ?, description = ?, dateDebut = ?, dateFin = ?, stagaireNom = ? , stagaireEmail = ?, entreprise = ?
        WHERE id=?;
      ''', [
        titleController.text,
        descriptionController.text,
        startDateController.text,
        endDateController.text,
        stagiaireNomController.text,
        stagiaireEmailController.text,
        entrepriseController.text,
        widget.idstage
      ]);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MyHomePage(idstage: widget.idstage)),
      ); // Return true when a stage is successfully added
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    stagiaireNomController.dispose();
    stagiaireEmailController.dispose();
    entrepriseController.dispose();
    super.dispose();
  }
}
