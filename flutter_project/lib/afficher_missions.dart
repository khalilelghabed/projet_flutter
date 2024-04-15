import 'package:flutter/material.dart';
import 'SqlDb.dart';
import 'add_mission.dart';
import 'modifier_mission.dart';
import 'drawer.dart';

class AfficherMissionsPage extends StatefulWidget {
  final String idStage;

  const AfficherMissionsPage({Key? key, required this.idStage})
      : super(key: key);

  @override
  _AfficherMissionsPageState createState() => _AfficherMissionsPageState();
}

class _AfficherMissionsPageState extends State<AfficherMissionsPage> {
  late Future<List<Map>> _missionsData;

  @override
  void initState() {
    super.initState();
    _fetchMissionsData();
  }

  // Méthode pour récupérer les données des missions
  Future<void> _fetchMissionsData() async {
    _missionsData = SqlDb()
        .readData('SELECT * FROM mission WHERE stageId = ?', [widget.idStage]);
    setState(() {}); // Rafraîchir l'affichage après avoir récupéré les données
  }

  // Méthode pour marquer la mission comme terminée
  void _markMissionAsCompleted(int missionId) async {
    // Mettre à jour l'état de la mission dans la base de données
    await SqlDb().updateData(
        'UPDATE mission SET etat = ? WHERE id = ?', [true, missionId]);
    // Rafraîchir les données des missions
    _fetchMissionsData();
  }

  // Méthode pour supprimer une mission
  Future<void> _deleteMission(int missionId) async {
    // Afficher une boîte de dialogue pour confirmer la suppression de la mission
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Supprimer la mission'),
          content: Text('Êtes-vous sûr de vouloir supprimer cette mission ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Return false on cancel
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Return true on confirm
              },
              child: Text('Supprimer'),
            ),
          ],
        );
      },
    ) ?? false; // Handling null (i.e., if the dialog is dismissed)

    // If confirmed, proceed with deletion
    if (confirmDelete) {
      // Delete the mission from the database
      await SqlDb().deleteData('DELETE FROM mission WHERE id = ?', [missionId]);
      // Refresh the mission list
      _fetchMissionsData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Missions",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 69, 98, 104),
      ),
      drawer: CustomDrawer(idstage: widget.idStage),
      body: FutureBuilder(
        future: _missionsData,
        builder: (BuildContext context, AsyncSnapshot<List<Map>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            // Afficher les missions
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var mission = snapshot.data![index];
                bool isCompleted = mission['etat'] == 1;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(mission['titre'] ?? ''),
                      subtitle: Text(
                          'Du ${mission['dateDebut']} au ${mission['dateFin']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Bouton Modifier
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ModifierMissionPage(
                                      missionId: mission['id']),
                                ),
                              );
                            },
                          ),
                          // Bouton Supprimer
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _deleteMission(mission['id']); // Supprimer la mission
                            },
                          ),
                          // Bouton Marquer comme terminée ou non terminée
                          IconButton(
                            icon: isCompleted
                                ? Icon(Icons.check_circle)
                                : Icon(Icons.circle),
                            onPressed: () {
                              _markMissionAsCompleted(mission[
                                  'id']); // Marquer la mission comme terminée
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MissionDetailsPage(
                              mission: mission.cast<String,
                                  dynamic>(), // Convertir la carte mission en Map<String, dynamic>
                            ),
                          ),
                        );
                      },
                    ),
                    Divider(), // Ajouter une ligne de séparation entre chaque mission
                  ],
                );
              },
            );
          } else {
            return Center(child: Text("Aucune mission trouvée."));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddMissionPage(stageId: widget.idStage)),
          ).then((_) {
            // Rafraîchir les données après l'ajout d'une nouvelle mission
            _fetchMissionsData();
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class MissionDetailsPage extends StatelessWidget {
  final Map<String, dynamic> mission;

  const MissionDetailsPage({Key? key, required this.mission}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de la Mission'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Titre : ${mission['titre'] ?? ''}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Description : ${mission['description'] ?? ''}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Date de début : ${mission['dateDebut']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Date de fin : ${mission['dateFin']}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
