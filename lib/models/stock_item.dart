class StockItem {
  final int? id;
  final String nom;
  final String categorie;
  final double quantite;
  final String unite;
  final double seuilMinimum;
  final String dateMaj;

  StockItem({
    this.id,
    required this.nom,
    required this.categorie,
    required this.quantite,
    this.unite = 'unité',
    this.seuilMinimum = 0,
    required this.dateMaj,
  });

  bool get enAlerte => quantite <= seuilMinimum;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'categorie': categorie,
      'quantite': quantite,
      'unite': unite,
      'seuilMinimum': seuilMinimum,
      'dateMaj': dateMaj,
    };
  }

  factory StockItem.fromMap(Map<String, dynamic> map) {
    return StockItem(
      id: map['id'],
      nom: map['nom'],
      categorie: map['categorie'],
      quantite: (map['quantite'] as num).toDouble(),
      unite: map['unite'] ?? 'unité',
      seuilMinimum: (map['seuilMinimum'] as num).toDouble(),
      dateMaj: map['dateMaj'],
    );
  }
}
