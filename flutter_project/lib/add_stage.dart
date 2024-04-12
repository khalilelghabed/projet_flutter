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
  TextEditingController stagiaireIdController = TextEditingController();
  TextEditingController departmentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Stage"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
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
              decoration: InputDecoration(labelText: 'Start Date'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the start date';
                }
                return null;
              },
            ),
            TextFormField(
              controller: endDateController,
              decoration: InputDecoration(labelText: 'End Date'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the end date';
                }
                return null;
              },
            ),
            TextFormField(
              controller: stagiaireIdController,
              decoration: InputDecoration(labelText: 'Stagiaire ID'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the stagiaire ID';
                }
                return null;
              },
            ),
            TextFormField(
              controller: departmentController,
              decoration: InputDecoration(labelText: 'Department'),
            ),
            ElevatedButton(
              onPressed: _addStage,
              child: Text('Add Stage'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addStage() async {
    if (_formKey.currentState!.validate()) {
      final db = SqlDb();
      await db.insertData('''
        INSERT INTO stage (id, titre, description, dateDebut, dateFin, stagiaireId, departement)
        VALUES (?, ?, ?, ?, ?, ?, ?)
      ''', [
        DateTime.now().millisecondsSinceEpoch.toString(), // Generating a unique ID based on timestamp
        titleController.text,
        descriptionController.text,
        startDateController.text,
        endDateController.text,
        stagiaireIdController.text,
        departmentController.text
      ]);
      Navigator.pop(context, true);  // Return true when a stage is successfully added
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    stagiaireIdController.dispose();
    departmentController.dispose();
    super.dispose();
  }
}
