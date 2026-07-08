import 'package:flutter/material.dart';
import '../core/database/db_helper.dart';
import '../models/devis.dart';

class DevisProvider extends ChangeNotifier {
  List<Devis> _devis = [];
  List<Devis> get devis => _devis;

  Future<void> loadDevis() async {
    final db = await DBHelper.instance.database;
    final result = await db.query('devis', orderBy: 'id DESC');
    _devis = result.map((e) => Devis.fromMap(e)).toList();
    notifyListeners();
  }

  /// Génère un numéro automatique du type DV-2026-0001
  Future<String> genererNumero() async {
    final db = await DBHelper.instance.database;
    final annee = DateTime.now().year;
    final result = await db.rawQuery(
        "SELECT COUNT(*) as total FROM devis WHERE numero LIKE 'DV-$annee-%'");
    final total = (result.first['total'] as int) + 1;
    return 'DV-$annee-${total.toString().padLeft(4, '0')}';
  }

  Future<void> addDevis(Devis d) async {
    final db = await DBHelper.instance.database;
    await db.insert('devis', d.toMap()..remove('id'));
    await loadDevis();
  }

  Future<void> updateStatut(int id, String statut) async {
    final db = await DBHelper.instance.database;
    await db.update('devis', {'statut': statut},
        where: 'id = ?', whereArgs: [id]);
    await loadDevis();
  }

  Future<void> deleteDevis(int id) async {
    final db = await DBHelper.instance.database;
    await db.delete('devis', where: 'id = ?', whereArgs: [id]);
    await loadDevis();
  }
}
