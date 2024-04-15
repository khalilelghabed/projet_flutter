import 'package:flutter/material.dart';
import 'SqlDb.dart';
import 'add_stage.dart';
import 'home_page.dart';

class StagePage extends StatefulWidget {
  const StagePage({Key? key}) : super(key: key);

  @override
  State<StagePage> createState() => _StagePageState();
}

class _StagePageState extends State<StagePage> {
  late Future<List<Map>> _stageData;
  TextEditingController _searchController = TextEditingController();
  final List<String> _selectedStageIds = [];

  @override
  void initState() {
    super.initState();
    _stageData = SqlDb().readData('SELECT * FROM stage');
  }

  void refreshStages() {
    setState(() {
      _stageData = SqlDb().readData('SELECT * FROM stage');
    });
  }

  Future<void> _handleRefresh() async {
    refreshStages();
  }

  void _searchStages(String query) {
    setState(() {
      _stageData = SqlDb().readData(
        'SELECT * FROM stage WHERE titre LIKE ?',
        ['%$query%'],
      );
    });
  }

  void _toggleStageSelection(String id) {
    setState(() {
      if (_selectedStageIds.contains(id)) {
        _selectedStageIds.remove(id);
      } else {
        _selectedStageIds.add(id);
      }
    });
  }

  Future<void> _deleteSelectedStages() async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmer la suppression'),
          content: Text('Êtes-vous sûr de vouloir supprimer les stages sélectionnés ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Supprimer'),
            ),
          ],
        );
      },
    ) ?? false;

    if (confirmDelete) {
      for (String id in _selectedStageIds) {
        await SqlDb().deleteData('DELETE FROM stage WHERE id = ?', [id]);
      }
      setState(() {
        _selectedStageIds.clear();
      });
      refreshStages();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des stages"),
        centerTitle: true,
        actions: _selectedStageIds.isNotEmpty
            ? [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _deleteSelectedStages,
                )
              ]
            : [],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Rechercher',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onChanged: _searchStages,
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: _stageData,
                builder:
                    (BuildContext context, AsyncSnapshot<List<Map>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var stage = snapshot.data![index];
                        bool isSelected = _selectedStageIds.contains(stage['id'].toString());
                        return ListTile(
                          title: Text(stage['titre'] ?? 'No Title'),
                          subtitle: Text("Début: ${stage['dateDebut']} - Fin: ${stage['dateFin']}"),
                          selected: isSelected,
                          selectedTileColor: Colors.blue[100],
                          onTap: () {
                            if (_selectedStageIds.isNotEmpty) {
                              _toggleStageSelection(stage['id'].toString());
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyHomePage(idstage: stage['id']),
                                ),
                              );
                            }
                          },
                          onLongPress: () => _toggleStageSelection(stage['id'].toString()),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text("Rien."));
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddStagePage()),
          );
          if (result == true) {
            refreshStages(); // Refresh the list when a stage is added
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
