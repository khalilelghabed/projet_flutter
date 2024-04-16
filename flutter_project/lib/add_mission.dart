import 'package:flutter/material.dart';
import 'SqlDb.dart';

class AddMissionPage extends StatefulWidget {
  final String stageId;

  const AddMissionPage({super.key, required this.stageId});

  @override
  _AddMissionPageState createState() => _AddMissionPageState();
}

class _AddMissionPageState extends State<AddMissionPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titreController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Mission"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            TextFormField(
              controller: titreController,
              decoration: const InputDecoration(labelText: 'titre'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            TextFormField(
              controller: startDateController,
              decoration: const InputDecoration(labelText: 'Start Date'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a start date';
                }
                return null;
              },
            ),
            TextFormField(
              controller: endDateController,
              decoration: const InputDecoration(labelText: 'End Date'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an end date';
                }
                return null;
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 69, 98, 104),
                ),
                foregroundColor: MaterialStateProperty.all<Color>(
                  Colors.white,
                ),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    await SqlDb().insertData('''
                      INSERT INTO mission (titre,description, dateDebut, dateFin, stageId)
                      VALUES (?,?, ?, ?, ?)
                    ''', [
                      titreController.text,
                      descriptionController.text,
                      startDateController.text,
                      endDateController.text,
                      widget.stageId,
                    ]);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Mission added successfully')),
                    );
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to add mission')),
                    );
                  }
                }
              },
              child: const Text('Add Mission'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    descriptionController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }
}