import 'package:flutter/material.dart';
import 'SqlDb.dart'; // Ensure this is pointing to your SqlDb class correctly

class AddStagePage extends StatefulWidget {
  const AddStagePage({super.key});

  @override
  State<AddStagePage> createState() => _AddStagePageState();
}

class _AddStagePageState extends State<AddStagePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController stagaireNomController = TextEditingController();
  TextEditingController stagaireEmailController = TextEditingController();
  TextEditingController entrepriseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter des stages"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            TextFormField(
              controller: entrepriseController,
              decoration: const InputDecoration(labelText: 'Entreprise'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextFormField(
              controller: startDateController,
              decoration: const InputDecoration(labelText: 'Date début'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the start date';
                }
                return null;
              },
            ),
            TextFormField(
              controller: endDateController,
              decoration: const InputDecoration(labelText: 'Date fin'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the end date';
                }
                return null;
              },
            ),
            TextFormField(
              controller: stagaireNomController,
              decoration: const InputDecoration(labelText: 'Stagaire nom complet'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the stagaire name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: stagaireEmailController,
              decoration: const InputDecoration(labelText: 'Stagaire email'),
            ),
            ElevatedButton(
              onPressed: _addStage,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 69, 98, 104),
                ),
                foregroundColor: MaterialStateProperty.all<Color>(
                  Colors.white,
                ),
              ),
              child: const Text('Ajouter'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addStage() async {
    if (_formKey.currentState!.validate()) {
      try {
        final db = SqlDb();
        await db.insertData('''
        INSERT INTO stage (id, titre, description, dateDebut, dateFin, stagaireNom, stagaireEmail, entreprise)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
      ''', [
          DateTime.now()
              .millisecondsSinceEpoch
              .toString(), // Generating a unique ID based on timestamp
          titleController.text,
          descriptionController.text,
          startDateController.text,
          endDateController.text,
          stagaireNomController.text,
          stagaireEmailController.text,
          entrepriseController.text
        ]);
        Navigator.pop(
            context, true); // Return true when a stage is successfully added
      } catch (e) {
        print('Error inserting stage: $e');
      }
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    stagaireNomController.dispose();
    stagaireEmailController.dispose();
    entrepriseController.dispose();
    super.dispose();
  }
}
