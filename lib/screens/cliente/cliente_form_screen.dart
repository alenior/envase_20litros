import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../../models/cliente.dart';
import '../../services/database_helper.dart';

class ClienteFormScreen extends StatefulWidget {
  final Cliente? cliente;

  const ClienteFormScreen({super.key, this.cliente});

  @override
  ClienteFormScreenState createState() => ClienteFormScreenState();
}

class ClienteFormScreenState extends State<ClienteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _nome, _endereco, _contato, _observacoes;
  final Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    _nome = widget.cliente?.nome ?? '';
    _endereco = widget.cliente?.endereco ?? '';
    _contato = widget.cliente?.contato ?? '';
    _observacoes = widget.cliente?.observacoes ?? '';
  }

Future<void> _saveCliente() async {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();
    try {
      final conn = await DatabaseHelper.connect();
      logger.i('Conexão com o banco de dados estabelecida.');

      if (widget.cliente == null) {
        // Inserção
        logger.i('Inserindo cliente: Nome=$_nome, Endereço=$_endereco, Contato=$_contato, Observações=$_observacoes');
        try {
          await conn.query(
            'INSERT INTO clientes (nome, endereco, contato, observacoes) VALUES (?, ?, ?, ?)',
            [_nome, _endereco, _contato, _observacoes],
          );
        } catch (e, stacktrace) {
          logger.e('Erro ao executar query', e, stacktrace);
        }

      } else {
        // Atualização
        logger.i('Atualizando cliente ID=${widget.cliente!.id}');
        await conn.query(
          'UPDATE clientes SET nome = ?, endereco = ?, contato = ?, observacoes = ? WHERE id = ?',
          [_nome, _endereco, _contato, _observacoes, widget.cliente!.id],
        );
      }
      await conn.close();
      logger.i('Operação realizada com sucesso.');
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      logger.i('Erro ao salvar cliente: $e');
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cliente == null ? 'Novo Cliente' : 'Editar Cliente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _nome,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o nome';
                  }
                  return null;
                },
                onSaved: (value) => _nome = value!,
              ),
              TextFormField(
                initialValue: _endereco,
                decoration: InputDecoration(labelText: 'Endereço'),
                onSaved: (value) => _endereco = value!,
              ),
              TextFormField(
                initialValue: _contato,
                decoration: InputDecoration(labelText: 'Contato'),
                onSaved: (value) => _contato = value!,
              ),
              TextFormField(
                initialValue: _observacoes,
                decoration: InputDecoration(labelText: 'Observações'),
                onSaved: (value) => _observacoes = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveCliente,
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
