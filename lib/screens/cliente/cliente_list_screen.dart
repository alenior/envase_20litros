import 'package:flutter/material.dart';
import '../../services/database_helper.dart';
import '../../models/cliente.dart';
import 'cliente_form_screen.dart'; // Tela para cadastro e edição de clientes

class ClienteListScreen extends StatefulWidget {
  const ClienteListScreen({super.key});

  @override
  ClienteListScreenState createState() => ClienteListScreenState();
}

class ClienteListScreenState extends State<ClienteListScreen> {
  List<Cliente> _clientes = [];
  List<Cliente> _filteredClientes = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  Future<void> _fetchClientes() async {
    final conn = await DatabaseHelper.connect();
    final results = await conn.query('SELECT * FROM clientes ORDER BY nome');
    setState(() {
      _clientes = results.map((row) => Cliente.fromMap(row.fields)).toList();
      _filteredClientes = _clientes;
      _isLoading = false;
    });
    await conn.close();
  }

  void _filterClientes(String query) {
    final filtered = _clientes.where((cliente) {
      final nomeLower = cliente.nome.toLowerCase();
      final enderecoLower = cliente.endereco.toLowerCase();
      final searchLower = query.toLowerCase();
      return nomeLower.contains(searchLower) || enderecoLower.contains(searchLower);
    }).toList();
    setState(() {
      _filteredClientes = filtered;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchClientes();
    _searchController.addListener(() {
      _filterClientes(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Voltar',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ClienteFormScreen(),
                ),
              ).then((_) => _fetchClientes());
            },
            tooltip: 'Novo Cliente',
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Pesquisar cliente por nome ou endereço',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredClientes.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhum cliente cadastrado.',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredClientes.length,
                        itemBuilder: (context, index) {
                          final cliente = _filteredClientes[index];
                          return ListTile(
                            title: Text(cliente.nome),
                            subtitle: Text(cliente.endereco),
                            onTap: () {
                              // Aqui pode-se adicionar navegação para detalhes ou edição
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
