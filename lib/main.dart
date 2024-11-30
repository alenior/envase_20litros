import 'package:flutter/material.dart';
import 'screens/cliente/cliente_list_screen.dart';
import 'screens/atendimento/atendimento_list_screen.dart';

void main() {
  runApp(Envase20LitrosApp());
}

class Envase20LitrosApp extends StatelessWidget {
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
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
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
