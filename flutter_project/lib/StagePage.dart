import 'package:flutter/material.dart';
import 'SqlDb.dart';
import 'add_stage.dart';
import 'home_page.dart';

class StagePage extends StatefulWidget {
  const StagePage({super.key});

  @override
  State<StagePage> createState() => _StagePageState();
}

class _StagePageState extends State<StagePage> {
  late Future<List<Map>> _stageData;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stages"),
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: FutureBuilder(
          future: _stageData,
          builder: (BuildContext context, AsyncSnapshot<List<Map>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var stage = snapshot.data![index];
                  return ListTile(
                    title: Text(stage['titre'] ?? 'No Title'),
                    subtitle: Text(
                        "Start: ${stage['dateDebut']} - End: ${stage['dateFin']}"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyHomePage(
                                  idstage: stage['id'],
                                )),
                      );
                    },
                  );
                },
              );
            } else {
              return const Center(child: Text("No stages found."));
            }
          },
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
