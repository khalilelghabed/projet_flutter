import 'package:flutter/material.dart';
import 'StagePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StageMate',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner:
          false, // Set to false to remove the debug banner
      home:
          const StagePage(), // Set MyHomePage as the initial route/home widget
    );
  }
}
