import 'package:flutter/material.dart';
import '../core/database/db_helper.dart';
import '../models/facture.dart';

class FactureProvider extends ChangeNotifier {
  List<Facture> _factures = [];
  List<Facture> get factures => _factures;

  Future<void> loadFactures() async {
    final db = await DBHelper.instance.database;
    final result = await db.query('factures', orderBy: 'id DESC');
    _factures = result.map((e) => Facture.fromMap(e)).toList();
    notifyListeners();
  }

  /// Génère un numéro automatique du type FA-2026-0001
  Future<String> genererNumero() async {
    final db = await DBHelper.instance.database;
    final annee = DateTime.now().year;
    final result = await db.rawQuery(
        "SELECT COUNT(*) as total FROM factures WHERE numero LIKE 'FA-$annee-%'");
    final total = (result.first['total'] as int) + 1;
    return 'FA-$annee-${total.toString().padLeft(4, '0')}';
  }

  Future<void> addFacture(Facture f) async {
    final db = await DBHelper.instance.database;
    await db.insert('factures', f.toMap()..remove('id'));
    await loadFactures();
  }

  Future<void> enregistrerPaiement(int id, double montant) async {
    final db = await DBHelper.instance.database;
    final facture = _factures.firstWhere((f) => f.id == id);
    final nouveauMontantPaye = facture.montantPaye + montant;
    await db.update('factures', {'montantPaye': nouveauMontantPaye},
        where: 'id = ?', whereArgs: [id]);
    await loadFactures();
  }

  Future<void> deleteFacture(int id) async {
    final db = await DBHelper.instance.database;
    await db.delete('factures', where: 'id = ?', whereArgs: [id]);
    await loadFactures();
  }

  double get chiffreAffairesTotal =>
      _factures.fold(0, (sum, f) => sum + f.montantTotal);

  double get totalEncaisse =>
      _factures.fold(0, (sum, f) => sum + f.montantPaye);
}
