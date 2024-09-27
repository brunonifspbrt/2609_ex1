class Moeda {
  String? origem;
  String? destino;
  String? nome;
  String? valorHigh;

  Moeda({
    required this.origem,
    required this.destino,
    required this.nome,
    required this.valorHigh,
  });

  // Método para converter um Map em um objeto Endereco
  factory Moeda.fromJson(Map<String, dynamic> json) {
    return Moeda(
      origem: json['code'],
      destino: json['codein'],
      nome: json['name'],
      valorHigh: json['high'],
    );
  }
}
