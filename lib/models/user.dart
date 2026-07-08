class AppUser {
  final int? id;
  final String nom;
  final String identifiant;
  final String role; // 'admin' ou 'employe'

  AppUser({
    this.id,
    required this.nom,
    required this.identifiant,
    required this.role,
  });

  bool get estAdmin => role == 'admin';

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'],
      nom: map['nom'],
      identifiant: map['identifiant'],
      role: map['role'],
    );
  }
}
