import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(const IconTestApp());
}

class IconTestApp extends StatelessWidget {
  const IconTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Teste Ícone'),
        ),
        body: Center(
          child: Icon(
            FontAwesomeIcons.magnifyingGlass, // Nome atualizado do ícone
            size: 50,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
