import 'package:flutter/material.dart'; // Import for debugPrintSizesEnabled
import 'package:project/homePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const Homepage());
  }
}
