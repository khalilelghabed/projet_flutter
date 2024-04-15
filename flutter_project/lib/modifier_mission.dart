import 'package:flutter/material.dart';
import 'sqldb.dart';
class ModifierMissionPage extends StatefulWidget {
  final int missionId;

  const ModifierMissionPage({Key? key, required this.missionId}) : super(key: key);

  @override
  _ModifierMissionPageState createState() => _ModifierMissionPageState();
}

class _ModifierMissionPageState extends State<ModifierMissionPage> {
  late TextEditingController _titreController;
  late TextEditingController _descriptionController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;

  @override
  void initState() {
    super.initState();
    _titreController = TextEditingController();
    _descriptionController = TextEditingController();
    _startDateController = TextEditingController();
    _endDateController = TextEditingController();
    _fetchMissionDetails();
  }

  Future<void> _fetchMissionDetails() async {
    List<Map> missionDetails = await SqlDb().readData('SELECT * FROM mission WHERE id = ?', [widget.missionId]);

    if (missionDetails.isNotEmpty) {
      Map<String, dynamic> firstMissionDetail = Map<String, dynamic>.from(missionDetails.first);
      setState(() {
        // Mettre à jour les contrôleurs avec les nouvelles valeurs
        _titreController.text = firstMissionDetail['titre'];
        _descriptionController.text = firstMissionDetail['description'];
        _startDateController.text = firstMissionDetail['dateDebut'];
        _endDateController.text = firstMissionDetail['dateFin'];
      });
    }
  }

  void _updateMission() async {
    // Récupérer les valeurs actuelles des contrôleurs
    String newTitle = _titreController.text;
    String newDescription = _descriptionController.text;
    String newStartDate = _startDateController.text;
    String newEndDate = _endDateController.text;

    // Mettre à jour les informations de la mission dans la base de données
    await SqlDb().updateData(
        'UPDATE mission SET titre = ?, description = ?, dateDebut = ?, dateFin = ? WHERE id = ?',
        [newTitle, newDescription, newStartDate, newEndDate, widget.missionId]);

    // Afficher un message de succès
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('La mission a été modifiée avec succès.'),
        backgroundColor: Colors.green,
      ),
    );

    // Retourner à la page précédente
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier Mission'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _titreController,
              decoration: InputDecoration(labelText: 'Titre'),
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextFormField(
              controller: _startDateController,
              decoration: InputDecoration(labelText: 'Date de début'),
            ),
            TextFormField(
              controller: _endDateController,
              decoration: InputDecoration(labelText: 'Date de fin'),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Annuler la modification et revenir à la page précédente
                    Navigator.pop(context);
                  },
                  child: Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Afficher une boîte de dialogue de confirmation avant de modifier la mission
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Confirmation'),
                        content: Text('Voulez-vous vraiment modifier cette mission ?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Fermer la boîte de dialogue
                            },
                            child: Text('Annuler'),
                          ),
                          TextButton(
                            onPressed: () {
                              _updateMission(); // Mettre à jour la mission
                              Navigator.pop(context); // Fermer la boîte de dialogue
                            },
                            child: Text('Confirmer'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text('Modifier Mission'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
