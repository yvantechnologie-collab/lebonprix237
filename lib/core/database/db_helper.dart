import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._internal();
  static Database? _database;

  DBHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'lebonprix237.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Utilisateurs (Admin / Employé)
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom TEXT NOT NULL,
        identifiant TEXT NOT NULL UNIQUE,
        motDePasse TEXT NOT NULL,
        role TEXT NOT NULL DEFAULT 'employe'
      )
    ''');

    // Compte administrateur par défaut : identifiant "admin" / mot de passe "admin237"
    await db.insert('users', {
      'nom': 'Administrateur',
      'identifiant': 'admin',
      'motDePasse': 'admin237',
      'role': 'admin',
    });

    // Clients
    await db.execute('''
      CREATE TABLE clients (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom TEXT NOT NULL,
        telephone TEXT,
        whatsapp TEXT,
        adresse TEXT,
        dateCreation TEXT NOT NULL
      )
    ''');

    // Devis
    await db.execute('''
      CREATE TABLE devis (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        numero TEXT NOT NULL,
        clientId INTEGER NOT NULL,
        description TEXT,
        montant REAL NOT NULL DEFAULT 0,
        statut TEXT NOT NULL DEFAULT 'en_attente',
        date TEXT NOT NULL,
        FOREIGN KEY (clientId) REFERENCES clients (id)
      )
    ''');

    // Factures
    await db.execute('''
      CREATE TABLE factures (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        numero TEXT NOT NULL,
        clientId INTEGER NOT NULL,
        devisRef TEXT,
        description TEXT,
        montantTotal REAL NOT NULL DEFAULT 0,
        montantPaye REAL NOT NULL DEFAULT 0,
        date TEXT NOT NULL,
        FOREIGN KEY (clientId) REFERENCES clients (id)
      )
    ''');

    // Stock
    await db.execute('''
      CREATE TABLE stock (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom TEXT NOT NULL,
        categorie TEXT NOT NULL,
        quantite REAL NOT NULL DEFAULT 0,
        unite TEXT NOT NULL DEFAULT 'unité',
        seuilMinimum REAL NOT NULL DEFAULT 0,
        dateMaj TEXT NOT NULL
      )
    ''');

    // Quelques matières premières par défaut (selon le spec)
    final matieresBase = [
      'Plexiglass', 'Bois MDF', 'Vinyle', 'Papier photo',
      'LED', 'Colle', 'Emballages', 'Accessoires'
    ];
    for (final m in matieresBase) {
      await db.insert('stock', {
        'nom': m,
        'categorie': 'Matière première',
        'quantite': 0,
        'unite': 'unité',
        'seuilMinimum': 5,
        'dateMaj': DateTime.now().toIso8601String(),
      });
    }
  }
}
