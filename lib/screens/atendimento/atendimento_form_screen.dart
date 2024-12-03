import 'package:flutter/material.dart';
import '../../models/atendimento.dart';
import '../../models/cliente.dart';
import '../../services/database_helper.dart';

class AtendimentoFormScreen extends StatefulWidget {
  final Atendimento? atendimento;

  const AtendimentoFormScreen({super.key, this.atendimento});

  @override
  AtendimentoFormScreenState createState() => AtendimentoFormScreenState();
}

class AtendimentoFormScreenState extends State<AtendimentoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  int? _clienteId;
  late int _quantidade;
  late String _observacao;
  DateTime _data = DateTime.now();
  List<Cliente> _clientes = [];

  @override
  void initState() {
    super.initState();
    _fetchClientes();
    if (widget.atendimento != null) {
      _clienteId = widget.atendimento!.clienteId;
      _quantidade = widget.atendimento!.quantidade;
      _observacao = widget.atendimento!.observacao;
      _data = widget.atendimento!.data;
    } else {
      _quantidade = 1;
      _observacao = '';
    }
  }

  Future<void> _fetchClientes() async {
    final conn = await DatabaseHelper.connect();
    final results = await conn.query('SELECT * FROM clientes');
    _clientes = results.map((row) {
      return Cliente(
        id: row['id'],
        nome: row['nome'],
        endereco: row['endereco'],
        contato: row['contato'],
        observacoes: row['observacoes'],
      );
    }).toList();
    setState(() {});
    await conn.close();
  }

  Future<void> _saveAtendimento() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final conn = await DatabaseHelper.connect();

      if (widget.atendimento == null) {
        // Inserção
        await conn.query(
          'INSERT INTO atendimentos (cliente_id, quantidade, data, observacao) VALUES (?, ?, ?, ?)',
          [_clienteId, _quantidade, _data.toIso8601String(), _observacao],
        );
      } else {
        // Atualização
        await conn.query(
          'UPDATE atendimentos SET cliente_id = ?, quantidade = ?, data = ?, observacao = ? WHERE id = ?',
          [_clienteId, _quantidade, _data.toIso8601String(), _observacao, widget.atendimento!.id],
        );
      }
      await conn.close();
      if(mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.atendimento == null ? 'Novo Atendimento' : 'Editar Atendimento'),
      ),
      body: _clientes.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    DropdownButtonFormField<int>(
                      value: _clienteId,
                      decoration: InputDecoration(labelText: 'Cliente'),
                      items: _clientes
                          .map((cliente) => DropdownMenuItem(
                                value: cliente.id,
                                child: Text(cliente.nome),
                              ))
                          .toList(),
                      onChanged: (value) => setState(() => _clienteId = value),
                      validator: (value) => value == null ? 'Selecione um cliente' : null,
                    ),
                    TextFormField(
                      initialValue: _quantidade.toString(),
                      decoration: InputDecoration(labelText: 'Quantidade'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || int.tryParse(value) == null || int.parse(value) <= 0) {
                          return 'Informe uma quantidade válida';
                        }
                        return null;
                      },
                      onSaved: (value) => _quantidade = int.parse(value!),
                    ),
                    TextFormField(
                      initialValue: _observacao,
                      decoration: InputDecoration(labelText: 'Observação'),
                      onSaved: (value) => _observacao = value!,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveAtendimento,
                      child: Text('Salvar'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
