class Facture {
  final int? id;
  final String numero;
  final int clientId;
  final String devisRef;
  final String description;
  final double montantTotal;
  final double montantPaye;
  final String date;

  Facture({
    this.id,
    required this.numero,
    required this.clientId,
    this.devisRef = '',
    required this.description,
    required this.montantTotal,
    this.montantPaye = 0,
    required this.date,
  });

  double get soldeRestant => montantTotal - montantPaye;
  bool get estSoldee => soldeRestant <= 0;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'numero': numero,
      'clientId': clientId,
      'devisRef': devisRef,
      'description': description,
      'montantTotal': montantTotal,
      'montantPaye': montantPaye,
      'date': date,
    };
  }

  factory Facture.fromMap(Map<String, dynamic> map) {
    return Facture(
      id: map['id'],
      numero: map['numero'],
      clientId: map['clientId'],
      devisRef: map['devisRef'] ?? '',
      description: map['description'] ?? '',
      montantTotal: (map['montantTotal'] as num).toDouble(),
      montantPaye: (map['montantPaye'] as num).toDouble(),
      date: map['date'],
    );
  }
}
