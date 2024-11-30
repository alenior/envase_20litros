import 'package:flutter/material.dart';
import '../../models/atendimento.dart';
import '../../services/database_helper.dart';

class AtendimentoListScreen extends StatefulWidget {
  @override
  _AtendimentoListScreenState createState() => _AtendimentoListScreenState();
}

class _AtendimentoListScreenState extends State<AtendimentoListScreen> {
  List<Atendimento> _atendimentos = [];
  String _searchDate = '';
  String _searchName = '';

  Future<void> _fetchAtendimentos() async {
    final conn = await DatabaseHelper.connect();
    final query = '''
      SELECT a.*, c.nome 
      FROM atendimentos a
      JOIN clientes c ON a.cliente_id = c.id
      WHERE c.nome LIKE ? AND a.data LIKE ?
      ORDER BY a.data, a.id
    ''';
    final results = await conn.query(
      query,
      ['%$_searchName%', '$_searchDate%'],
    );
    setState(() {
      _atendimentos = results.map((row) => Atendimento.fromMap(row.fields)).toList();
    });
    await conn.close();
  }

  @override
  void initState() {
    super.initState();
    _fetchAtendimentos();
  }

  void _onSearchChanged() {
    _fetchAtendimentos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Atendimentos'),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: () {
              // Implementar geração de PDF aqui
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(labelText: 'Pesquisar por nome'),
                  onChanged: (value) {
                    setState(() {
                      _searchName = value;
                    });
                    _onSearchChanged();
                  },
                ),
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(labelText: 'Pesquisar por data'),
                  onChanged: (value) {
                    setState(() {
                      _searchDate = value;
                    });
                    _onSearchChanged();
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _atendimentos.length,
              itemBuilder: (context, index) {
                final atendimento = _atendimentos[index];
                return ListTile(
                  title: Text('Cliente ID: ${atendimento.clienteId}'),
                  subtitle: Text('Quantidade: ${atendimento.quantidade}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
