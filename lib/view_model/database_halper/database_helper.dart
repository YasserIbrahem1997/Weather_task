import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:weather_journal/model/Weather_model.dart';

import '../../main.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'weather.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTable,
    );
  }

  Future<void> _createTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE weather(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cityName TEXT NOT NULL,
        temperature REAL NOT NULL,
        condition TEXT NOT NULL,
        humidity INTEGER NOT NULL,
        windSpeed REAL NOT NULL,
        description TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertWeather(Weather weather) async {
    final db = await database;
    return await db.insert('weather', weather.toMap());
  }

  Future<List<Weather>> getAllWeather() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('weather');
    return List.generate(maps.length, (i) => Weather.fromMap(maps[i]));
  }

  Future<int> deleteWeather(int id) async {
    final db = await database;
    return await db.delete('weather', where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> cityExists(String cityName) async {
    final db = await database;
    final result = await db.query(
      'weather',
      where: 'LOWER(cityName) = ?',
      whereArgs: [cityName.toLowerCase()],
    );
    return result.isNotEmpty;
  }
}
