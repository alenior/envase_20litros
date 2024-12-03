import 'package:flutter/material.dart';
import '../../services/database_helper.dart';
import '../../models/cliente.dart';
import 'cliente_form_screen.dart'; // A tela para cadastro e edição de clientes

class ClienteListScreen extends StatefulWidget {
  const ClienteListScreen({super.key});

  @override
  ClienteListScreenState createState() => ClienteListScreenState();
}

class ClienteListScreenState extends State<ClienteListScreen> {
  List<Cliente> _clientes = [];

  // Função para buscar clientes do banco de dados
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
    _fetchClientes(); // Carregar clientes ao iniciar a tela
  }

  // Função para excluir um cliente
  Future<void> _deleteCliente(int id) async {
    final conn = await DatabaseHelper.connect();
    await conn.query('DELETE FROM clientes WHERE id = ?', [id]);
    await conn.close();
    _fetchClientes(); // Atualizar a lista após exclusão
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clientes'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          // Botão para adicionar um novo cliente
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClienteFormScreen(), // Tela para adicionar novo cliente
                ),
              );
            },
          ),
        ],
      ),
      body: _clientes.isEmpty
          ? Center(child: CircularProgressIndicator()) // Exibir carregando se não houver dados
          : ListView.builder(
              itemCount: _clientes.length,
              itemBuilder: (context, index) {
                final cliente = _clientes[index];
                return ListTile(
                  title: Text(cliente.nome),
                  subtitle: Text(cliente.endereco),
                  trailing: PopupMenuButton<int>(
                    onSelected: (value) async {
                      if (value == 1) {
                        // Editar cliente
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ClienteFormScreen(cliente: cliente), // Passa o cliente para edição
                          ),
                        );
                      } else if (value == 2) {
                        // Excluir cliente
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Excluir Cliente'),
                            content: Text('Você tem certeza que deseja excluir este cliente?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Fechar o diálogo
                                },
                                child: Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (cliente.id != null) {
                                    _deleteCliente(cliente.id!); // Excluir cliente
                                  }
                                  Navigator.pop(context); // Fechar o diálogo
                                },
                                child: Text('Confirmar'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem<int>(
                        value: 1,
                        child: Text('Editar'),
                      ),
                      PopupMenuItem<int>(
                        value: 2,
                        child: Text('Excluir'),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
