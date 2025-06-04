import 'package:flutter/material.dart';
import 'package:pantrypal/constants/theme.dart';

void main(){
  runApp(const PantryPalApp());
}

class PantryPalApp extends StatelessWidget {
  const PantryPalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pantry Pal',
      theme: appTheme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Pantry Pal'),
        ),
        body: const Center(
          child: Text('Welcome to Pantry Pal!'),
        ),
      ),
    );
  }
}