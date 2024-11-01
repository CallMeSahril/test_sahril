import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:test_sahril/data/model/office_model.dart';

class OfficeDatabase {
  static final OfficeDatabase instance = OfficeDatabase._init();
  static Database? _database;

  OfficeDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('office.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 2, // Ubah versi jika sudah ada tabel
      onCreate: _createDB,
      onUpgrade: _upgradeDB, // Tambahkan ini untuk menangani pembaruan
    );
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
          'ALTER TABLE office ADD COLUMN radius INTEGER NOT NULL DEFAULT 0');
    }
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE office (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      waktuMasuk TEXT NOT NULL,
      waktuPulang TEXT NOT NULL,
      latitude REAL NOT NULL,
      longitude REAL NOT NULL,
      radius INTEGER NOT NULL,
      createdAt TEXT NOT NULL
    )
    ''');
  }

  Future<Office> create(Office office) async {
    final db = await instance.database;
    final id = await db.insert('office', office.toMap());
    return office.copy(id: id);
  }

  Future<Office?> readOffice(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'office',
      columns: [
        'id',
        'name',
        'waktuMasuk',
        'waktuPulang',
        'latitude',
        'longitude',
        'radius',
        'createdAt'
      ],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Office.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Office>> readAllOffices() async {
    final db = await instance.database;
    final result = await db.query('office');
    return result.map((json) => Office.fromMap(json)).toList();
  }

  Future<int> update(Office office) async {
    final db = await instance.database;
    return db.update(
      'office',
      office.toMap(),
      where: 'id = ?',
      whereArgs: [office.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      'office',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
