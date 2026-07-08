class Client {
  final int? id;
  final String nom;
  final String telephone;
  final String whatsapp;
  final String adresse;
  final String dateCreation;

  Client({
    this.id,
    required this.nom,
    required this.telephone,
    required this.whatsapp,
    required this.adresse,
    required this.dateCreation,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'telephone': telephone,
      'whatsapp': whatsapp,
      'adresse': adresse,
      'dateCreation': dateCreation,
    };
  }

  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      id: map['id'],
      nom: map['nom'],
      telephone: map['telephone'] ?? '',
      whatsapp: map['whatsapp'] ?? '',
      adresse: map['adresse'] ?? '',
      dateCreation: map['dateCreation'],
    );
  }
}
