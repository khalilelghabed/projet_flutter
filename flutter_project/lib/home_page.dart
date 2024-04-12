import 'package:flutter/material.dart';
import 'drawer.dart'; // Make sure this points to your custom drawer file

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drawer Demo'),
      ),
      drawer: const CustomDrawer(), // Use the newly named CustomDrawer widget
      body: const Center(
        child: Text('Swipe left or tap the icon to open the drawer.'),
      ),
    );
  }
}
