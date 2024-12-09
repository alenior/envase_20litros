class Cliente {
  final int? id;
  final String nome;
  final String endereco;
  final String contato;
  final String observacoes;

  Cliente({
    this.id,
    required this.nome,
    this.endereco = '',
    this.contato = '',
    this.observacoes = '',
  });

  /// Cria um objeto Cliente a partir de um Map
  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      id: map['id'],
      nome: map['nome'],
      endereco: map['endereco'] ?? '',
      contato: map['contato'] ?? '',
      observacoes: map['observacoes'] ?? '',
    );
  }

  /// Converte um objeto Cliente para um Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'endereco': endereco,
      'contato': contato,
      'observacoes': observacoes,
    };
  }
}
