import 'package:flutter/material.dart';
import '../core/database/db_helper.dart';
import '../models/client.dart';

class ClientProvider extends ChangeNotifier {
  List<Client> _clients = [];
  List<Client> get clients => _clients;

  Future<void> loadClients() async {
    final db = await DBHelper.instance.database;
    final result = await db.query('clients', orderBy: 'nom ASC');
    _clients = result.map((e) => Client.fromMap(e)).toList();
    notifyListeners();
  }

  Future<void> addClient(Client client) async {
    final db = await DBHelper.instance.database;
    await db.insert('clients', client.toMap()..remove('id'));
    await loadClients();
  }

  Future<void> updateClient(Client client) async {
    final db = await DBHelper.instance.database;
    await db.update('clients', client.toMap(),
        where: 'id = ?', whereArgs: [client.id]);
    await loadClients();
  }

  Future<void> deleteClient(int id) async {
    final db = await DBHelper.instance.database;
    await db.delete('clients', where: 'id = ?', whereArgs: [id]);
    await loadClients();
  }

  Client? getById(int id) {
    try {
      return _clients.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}
