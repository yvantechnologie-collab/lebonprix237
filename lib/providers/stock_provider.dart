import 'package:flutter/material.dart';
import '../core/database/db_helper.dart';
import '../models/stock_item.dart';

class StockProvider extends ChangeNotifier {
  List<StockItem> _stock = [];
  List<StockItem> get stock => _stock;

  List<StockItem> get alertes =>
      _stock.where((s) => s.enAlerte).toList();

  Future<void> loadStock() async {
    final db = await DBHelper.instance.database;
    final result = await db.query('stock', orderBy: 'nom ASC');
    _stock = result.map((e) => StockItem.fromMap(e)).toList();
    notifyListeners();
  }

  Future<void> addItem(StockItem item) async {
    final db = await DBHelper.instance.database;
    await db.insert('stock', item.toMap()..remove('id'));
    await loadStock();
  }

  Future<void> updateItem(StockItem item) async {
    final db = await DBHelper.instance.database;
    await db.update('stock', item.toMap(),
        where: 'id = ?', whereArgs: [item.id]);
    await loadStock();
  }

  /// [quantiteChange] positif pour une entrée, négatif pour une sortie
  Future<void> mouvementStock(int id, double quantiteChange) async {
    final db = await DBHelper.instance.database;
    final item = _stock.firstWhere((s) => s.id == id);
    final nouvelleQuantite = item.quantite + quantiteChange;
    await db.update(
      'stock',
      {
        'quantite': nouvelleQuantite < 0 ? 0 : nouvelleQuantite,
        'dateMaj': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
    await loadStock();
  }

  Future<void> deleteItem(int id) async {
    final db = await DBHelper.instance.database;
    await db.delete('stock', where: 'id = ?', whereArgs: [id]);
    await loadStock();
  }
}
