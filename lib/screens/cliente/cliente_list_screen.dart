import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import '../../services/database_helper.dart';
import '../../models/cliente.dart';

class ClienteListScreen extends StatefulWidget {
  @override
  _ClienteListScreenState createState() => _ClienteListScreenState();
}

class _ClienteListScreenState extends State<ClienteListScreen> {
  List<Cliente> _clientes = [];

  Future<void> _fetchClientes() async {
    final conn = await DatabaseHelper.connect();
    final results = await conn.query('SELECT * FROM clientes ORDER BY nome');
    setState(() {
      _clientes = results.map((row) => Cliente.fromMap(row.fields)).toList();
    });
    await conn.close();
  }

  @override
  void initState() {
    super.initState();
    _fetchClientes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Clientes')),
      body: ListView.builder(
        itemCount: _clientes.length,
        itemBuilder: (context, index) {
          final cliente = _clientes[index];
          return ListTile(
            title: Text(cliente.nome),
            subtitle: Text(cliente.endereco),
          );
        },
      ),
    );
  }
}
