// stage.dart
import 'package:flutter/material.dart';

class StagePage extends StatelessWidget {
  const StagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stages"),
      ),
      body: Center(
        child: Text("Welcome to the Stages Page!"),
      ),
    );
  }
}
