
import 'package:app_cep/screens/search_screen.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seu App',
      theme: ThemeData.dark(), // Tema escuro
      home: SearchScreen(), // Defina a SearchScreen como a página inicial
    );
  }
}

