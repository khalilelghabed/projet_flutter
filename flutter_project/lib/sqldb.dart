import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb {
  static Database? _db;

  // Getter to ensure we only have a single instance of the database.
  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialDb();
      return _db;
    } else {
      return _db;
    }
  }

  // Initialize the database.
  initialDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'firsttt.db');
    Database mydb = await openDatabase(path,
        onCreate: _onCreate, version: 1, onUpgrade: _onUpgrade);
    return mydb;
  }

  // Handle database upgrades.
  _onUpgrade(Database db, int oldVersion, int newVersion) {
  }

  // Create tables upon database creation.
  _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE utilisateur (
        id TEXT PRIMARY KEY,
        nom TEXT,
        prenom TEXT,
        email TEXT,
        telephone TEXT
      );
    ''');

    /*await db.execute('''
      CREATE TABLE stagiaire (
        id TEXT PRIMARY KEY,
        nom TEXT,
        prenom TEXT,
        email TEXT,
        telephone TEXT
      );
    ''');*/
    await db.execute('''
      CREATE TABLE stage (
        id TEXT PRIMARY KEY,
        titre TEXT,
        description TEXT,
        dateDebut TEXT,
        dateFin TEXT,
        stagaireNom TEXT,
        stagaireEmail TEXT,
        entreprise TEXT,
        photoProfil BLOB
      );
    ''');
    await db.execute('''
      CREATE TABLE mission (

    id INTEGER PRIMARY KEY AUTOINCREMENT,
    titre TEXT , 
    description TEXT,
    dateDebut TEXT,
    dateFin TEXT,
    etat BOOLEAN DEFAULT false,
    stageId TEXT,
    FOREIGN KEY (stageId) REFERENCES stage(id)
  );
''');
    /*await db.execute('''
      CREATE TABLE realisation (
        titre TEXT,
        description TEXT,
        date TEXT,
        stageId TEXT,
        FOREIGN KEY (stageId) REFERENCES stage(id)
      );
    ''');*/
    await db.execute('''
      CREATE TABLE objectif (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titre TEXT,
        description TEXT,
        dateLimite TEXT,
        critereReussite TEXT,
        stageId TEXT,
        FOREIGN KEY (stageId) REFERENCES stage(id)
      );
    ''');
  }

  // CRUD Operations:

  // Read Data
  Future<List<Map>> readData(String sql, [List<dynamic>? parameters]) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql, parameters);
    return response;
  }

  // Insert Data
  Future<int> insertData(String sql, [List<dynamic>? parameters]) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql, parameters);
    return response;
  }

  // Update Data
  Future<int> updateData(String sql, [List<dynamic>? parameters]) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql, parameters);
    return response;
  }

  // Delete Data
  Future<int> deleteData(String sql, [List<dynamic>? parameters]) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql, parameters);
    return response;
  }
}
