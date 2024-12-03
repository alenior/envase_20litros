import 'package:flutter/material.dart';
import 'screens/cliente/cliente_list_screen.dart';
import 'screens/atendimento/atendimento_list_screen.dart';
import 'screens/cliente/cliente_form_screen.dart';
import 'screens/atendimento/atendimento_form_screen.dart';

void main() {
  runApp(Envase20LitrosApp());
}

class Envase20LitrosApp extends StatelessWidget {
  const Envase20LitrosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Envase 20 Litros',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/clientes': (context) => ClienteListScreen(),
        '/atendimentos': (context) => AtendimentoListScreen(),
        '/novo-cliente': (context) => ClienteFormScreen(),
        '/novo-atendimento': (context) => AtendimentoFormScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Envase 20 Litros')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/clientes'),
              child: Text('Gerenciar Clientes'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/atendimentos'),
              child: Text('Gerenciar Atendimentos'),
            ),
          ],
        ),
      ),
    );
  }
}
