import 'package:flutter/material.dart';
import 'screens/cliente/cliente_list_screen.dart';
import 'screens/atendimento/atendimento_list_screen.dart';
import 'screens/cliente/cliente_form_screen.dart';
import 'screens/atendimento/atendimento_form_screen.dart';

void main() {
  runApp(const Envase20LitrosApp());
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
        useMaterial3: true, // Habilita o Material Design 3
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/clientes': (context) => const ClienteListScreen(),
        '/atendimentos': (context) => const AtendimentoListScreen(),
        '/novo-cliente': (context) => const ClienteFormScreen(),
        '/novo-atendimento': (context) => const AtendimentoFormScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Águas Giovanna'),
      ),
      body: Stack(
        children: [
          // Marca d'água ao fundo
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                'assets/logo_aguas_giovanna.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Conteúdo principal no topo, centralizado horizontalmente
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 40.0),
                child: Text(
                  'Bem-vindo ao sistema de gestão',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/clientes'),
                    child: const Text('Gerenciar Clientes'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/atendimentos'),
                    child: const Text('Gerenciar Atendimentos'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
