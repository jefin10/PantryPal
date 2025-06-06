import 'package:flutter/material.dart';
import 'package:pantrypal/auth/login.dart';
import 'package:pantrypal/constants/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // This is needed to ensure plugin initialization
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize shared preferences (this will help prevent the error)
  await SharedPreferences.getInstance();
  
  runApp(const PantryPalApp());
}

class PantryPalApp extends StatelessWidget {
  const PantryPalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pantry Pal',
      theme: appTheme,
      home: Login(),
    );
  }
}