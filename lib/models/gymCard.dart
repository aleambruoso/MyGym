class GymCard {
  final String nome;
  final String note;
  final int id;

  GymCard(this.id, this.nome, this.note);

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'note': note,
    };
  }
}
