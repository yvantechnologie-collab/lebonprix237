/// Statuts possibles : en_attente, accepte, refuse
class Devis {
  final int? id;
  final String numero;
  final int clientId;
  final String description;
  final double montant;
  final String statut;
  final String date;

  Devis({
    this.id,
    required this.numero,
    required this.clientId,
    required this.description,
    required this.montant,
    this.statut = 'en_attente',
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'numero': numero,
      'clientId': clientId,
      'description': description,
      'montant': montant,
      'statut': statut,
      'date': date,
    };
  }

  factory Devis.fromMap(Map<String, dynamic> map) {
    return Devis(
      id: map['id'],
      numero: map['numero'],
      clientId: map['clientId'],
      description: map['description'] ?? '',
      montant: (map['montant'] as num).toDouble(),
      statut: map['statut'],
      date: map['date'],
    );
  }

  String get statutLabel {
    switch (statut) {
      case 'accepte':
        return 'Accepté';
      case 'refuse':
        return 'Refusé';
      default:
        return 'En attente';
    }
  }
}
