class Atendimento {
  final int? id;
  final int clienteId;
  final int quantidade;
  final DateTime data;
  final String observacao;

  Atendimento({
    this.id,
    required this.clienteId,
    required this.quantidade,
    required this.data,
    this.observacao = '',
  });

  factory Atendimento.fromMap(Map<String, dynamic> map) {
    return Atendimento(
      id: map['id'],
      clienteId: map['cliente_id'],
      quantidade: map['quantidade'],
      data: DateTime.parse(map['data']),
      observacao: map['observacao'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cliente_id': clienteId,
      'quantidade': quantidade,
      'data': data.toIso8601String(),
      'observacao': observacao,
    };
  }
}
