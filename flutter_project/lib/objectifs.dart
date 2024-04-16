import 'package:flutter/material.dart';
import 'drawer.dart'; // Make sure this points to your custom drawer file
import 'SqlDb.dart';

class Objectif extends StatefulWidget {
  const Objectif({super.key, required this.idstage});
  final String idstage;

  @override
  State<Objectif> createState() => _ObjectifState();
}

class _ObjectifState extends State<Objectif> {
  late Future<List<Map>> _objectifsData;
  final _formKey = GlobalKey<FormState>();
  TextEditingController titreController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController datelimitController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _objectifsData = SqlDb()
        .readData('SELECT * FROM objectif where stageId=?', [widget.idstage]);
    //_objectifsData = SqlDb().readData('SELECT * FROM mission where etat=?', [1]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Objectifs",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 69, 98, 104),
      ),
      drawer: CustomDrawer(
          idstage: widget.idstage), // Use the newly named CustomDrawer widget
      body: FutureBuilder(
        future: _objectifsData,
        builder: (BuildContext context, AsyncSnapshot<List<Map>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var objectif = snapshot.data![index];
                return Padding(
                  padding:
                      const EdgeInsets.only(right: 8.0, left: 8.0, top: 8.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.only(left: 10, right: 10),
                    title: Text(objectif['titre'] ?? 'Aucun titre'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            color: Colors.white,
                          ),
                          child: SizedBox(
                              height: 100,
                              width: 400,
                              child: Text(
                                "Descriptions : ${objectif["description"]}",
                                style: const TextStyle(color: Colors.black),
                              )),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Date limite : ${objectif["dateLimite"]}"),
                            Row(
                              children: [
                                IconButton(
                                  color: Colors.white,
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return objectifeditdialog(objectif);
                                        });
                                  },
                                ),
                                IconButton(
                                  color: Colors.white,
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    _deleteobjectif(objectif["id"]);
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
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
            return const Center(child: Text("No objectifs."));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 227, 254, 247),
        foregroundColor: const Color.fromARGB(255, 69, 98, 104),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return objectifdialog();
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  AlertDialog objectifeditdialog(objectif) {
    titreController.text = objectif["titre"];
    descriptionController.text = objectif["description"];
    datelimitController.text = objectif["dateLimite"];
    return AlertDialog(
      title: const Text(
        "Ajouter un objectif",
        style: TextStyle(color: Color.fromARGB(255, 0, 60, 67)),
      ),
      content: Form(
        key: _formKey,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextFormField(
            controller: titreController,
            decoration: const InputDecoration(
              labelText: "Titre d'objectif",
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Champ obligatoire';
              }
              return null;
            },
          ),
          TextFormField(
            controller: descriptionController,
            decoration: const InputDecoration(
              labelText: "Description d'objectif",
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Champ obligatoire';
              }
              return null;
            },
          ),
          TextFormField(
            controller: datelimitController,
            decoration: const InputDecoration(
              labelText: "Date limit d'objectif",
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Champ obligatoire';
              }
              return null;
            },
          ),
        ]),
      ),
      actions: [
        IconButton(
            color: const Color.fromARGB(255, 0, 60, 67),
            onPressed: () {
              Navigator.pop(context);
              clearcontrollers();
            },
            icon: const Icon(Icons.close)),
        IconButton(
            color: const Color.fromARGB(255, 0, 60, 67),
            onPressed: () {
              _modifyobjectif(objectif["id"]);
            },
            icon: const Icon(Icons.check)),
      ],
    );
  }

  Future<void> _modifyobjectif(id) async {
    if (_formKey.currentState!.validate()) {
      final db = SqlDb();
      await db.updateData('''
        UPDATE objectif SET titre = ?, description = ?, dateLimite = ? WHERE id = ?
      ''', [
        titreController.text,
        descriptionController.text,
        datelimitController.text,
        id,
      ]);

      Navigator.pop(context, true);
      setState(() {
        _objectifsData = SqlDb().readData(
            'SELECT * FROM objectif where stageId=?', [widget.idstage]);
      });
      clearcontrollers();
    }
  }

  AlertDialog objectifdialog() {
    return AlertDialog(
      title: const Text(
        "Ajouter un objectif",
        style: TextStyle(color: Color.fromARGB(255, 0, 60, 67)),
      ),
      content: Form(
        key: _formKey,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextFormField(
            controller: titreController,
            decoration: const InputDecoration(
              labelText: "Titre d'objectif",
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Champ obligatoire';
              }
              return null;
            },
          ),
          TextFormField(
            controller: descriptionController,
            decoration: const InputDecoration(
              labelText: "Description d'objectif",
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Champ obligatoire';
              }
              return null;
            },
          ),
          TextFormField(
            controller: datelimitController,
            decoration: const InputDecoration(
              labelText: "Date limit d'objectif",
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Champ obligatoire';
              }
              return null;
            },
          ),
        ]),
      ),
      actions: [
        IconButton(
            color: const Color.fromARGB(255, 0, 60, 67),
            onPressed: () {
              Navigator.pop(context);
              clearcontrollers();
            },
            icon: const Icon(Icons.close)),
        IconButton(
            color: const Color.fromARGB(255, 0, 60, 67),
            onPressed: () {
              _addobjectif(widget.idstage);
            },
            icon: const Icon(Icons.check)),
      ],
    );
  }

  Future<void> _deleteobjectif(id) async {
    final db = SqlDb();
    await db.deleteData('''
      DELETE FROM objectif
      WHERE id=?;
    ''', [id]);

    setState(() {
      _objectifsData = SqlDb()
          .readData('SELECT * FROM objectif where stageId=?', [widget.idstage]);
    });
  }

  Future<void> _addobjectif(stageId) async {
    if (_formKey.currentState!.validate()) {
      final db = SqlDb();
      await db.insertData('''
        INSERT INTO objectif (titre, description, dateLimite,stageId)
        VALUES (?, ?, ?,?)
      ''', [
        titreController.text,
        descriptionController.text,
        datelimitController.text,
        stageId,
      ]);

      Navigator.pop(context, true);
      setState(() {
        _objectifsData = SqlDb().readData(
            'SELECT * FROM objectif where stageId=?', [widget.idstage]);
      });
      clearcontrollers();
    }
  }

  void clearcontrollers() {
    titreController.clear();
    descriptionController.clear();
    datelimitController.clear();
  }

  @override
  void dispose() {
    titreController.dispose();
    descriptionController.dispose();
    datelimitController.dispose();
    super.dispose();
  }
}
