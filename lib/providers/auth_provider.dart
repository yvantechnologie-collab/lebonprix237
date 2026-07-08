import 'package:flutter/material.dart';
import '../core/database/db_helper.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  Future<String?> login(String identifiant, String motDePasse) async {
    final db = await DBHelper.instance.database;
    final result = await db.query(
      'users',
      where: 'identifiant = ? AND motDePasse = ?',
      whereArgs: [identifiant, motDePasse],
    );

    if (result.isEmpty) {
      return 'Identifiant ou mot de passe incorrect';
    }

    _currentUser = AppUser.fromMap(result.first);
    notifyListeners();
    return null; // pas d'erreur
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
