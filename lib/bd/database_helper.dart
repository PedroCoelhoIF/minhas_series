import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'minhas_series.db');
    
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE series (
        id INTEGER NOT NULL,
        user_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        poster_path TEXT,
        status TEXT NOT NULL,
        rating REAL,
        comment TEXT,
        PRIMARY KEY (id, user_id),
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');
  }

  
  Future<int> createUser(String username, String password) async {
    final db = await database;
    return db.insert('users', {'username': username, 'password': password},
        conflictAlgorithm: ConflictAlgorithm.fail);
  }

  Future<Map<String, dynamic>?> getUser(String username, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users',
        where: 'username = ? AND password = ?', whereArgs: [username, password]);
    if (maps.isNotEmpty) return maps.first;
    return null;
  }

  
  Future<void> saveSeries(Map<String, dynamic> seriesData) async {
    final db = await database;
    await db.insert('series', seriesData,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getSeriesByStatus(String status, int userId) async {
    final db = await database;
    return db.query('series',
        where: 'status = ? AND user_id = ?', whereArgs: [status, userId]);
  }

  Future<Map<String, dynamic>?> getSeriesById(int seriesId, int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('series',
        where: 'id = ? AND user_id = ?', whereArgs: [seriesId, userId]);
    if (maps.isNotEmpty) return maps.first;
    return null;
  }

  
  Future<void> deleteSeries(int seriesId, int userId) async {
    final db = await database;
    await db.delete(
      'series',
      where: 'id = ? AND user_id = ?',
      whereArgs: [seriesId, userId],
    );
  }
}