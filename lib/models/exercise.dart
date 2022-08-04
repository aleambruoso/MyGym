class Exercise {
  final int id;
  final String nome;
  final int serie;
  final String ripetizioni;
  final String pausa;
  final int giorno;
  final int n_ordine;
  final int schedaId;
  final String note;

  Exercise(
    this.id,
    this.nome,
    this.serie,
    this.ripetizioni,
    this.pausa,
    this.giorno,
    this.n_ordine,
    this.note,
    this.schedaId,
  );

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'serie': serie,
      'ripetizioni': ripetizioni,
      'pausa': pausa,
      'giorno': giorno,
      'n_ordine': n_ordine,
      'note': note,
      'schedaId': schedaId
    };
  }
}
