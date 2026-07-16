import 'package:habittrack/models/habit.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:habittrack/models/check_in.dart';
import 'package:habittrack/models/urge.dart';


class DatabaseHelper {
  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async{
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async{
    final dbPath = await getDatabasesPath();
    final fullPath = join(dbPath, 'habit_track.db');
    return await openDatabase(
      fullPath,
      version: 1,
      onCreate: _onCreate
    );
  }
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE habits (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    ''');
    await db.execute('''
      CREATE TABLE check_ins (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      habit_id INTEGER NOT NULL,
      date TEXT NOT NULL,
      status TEXT NOT NULL,
      note TEXT,
      FOREIGN KEY (habit_id) REFERENCES habits(id)
      );
    ''');
    await db.execute('''
    CREATE TABLE urges (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      habit_id INTEGER NOT NULL,
      timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      intensity INTEGER,
      trigger_note TEXT,
      FOREIGN KEY (habit_id) REFERENCES habits(id)
    );
    ''');
  }

  Future<int> insertHabit(Habit habit) async{
    final db = await database;
    return await db.insert('habits', habit.toMap());
  }

  Future<List<Habit>> getHabits() async{
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('habits');
    return List.generate(maps.length, (i) => Habit.fromMap(maps[i]));
  }

  Future<int> insertCheckIn(CheckIn checkIn) async{
    final db = await database;
    return await db.insert('check_ins', checkIn.toMap());
  }

  Future<List<CheckIn>> getCheckInsForHabit(int habitId) async{
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'check_ins',
      where: 'habit_id = ?',
      whereArgs: [habitId],
      orderBy: 'date ASC',
    );
    return List.generate(maps.length, (i) => CheckIn.fromMap(maps[i]));
  }

  Future<int> insertUrge(Urge urge) async{
    final db = await database;
    return await db.insert('urges', urge.toMap());
  }

  Future<List<Urge>> getUrgesForHabit(int habitId) async{
    final db = await database;
    final List<Map<String,dynamic>> maps = await db.query(
      'urges',
      where: 'habit_id = ?',
      whereArgs: [habitId],
      orderBy: 'timestamp ASC',
    );
    return List.generate(maps.length, (i) => Urge.fromMap(maps[i]));
  }
  // add to lib/db/database_helper.dart

Future<void> deleteHabit(int habitId) async {
  final db = await database;
  await db.delete('check_ins', where: 'habit_id = ?', whereArgs: [habitId]);
  await db.delete('urges', where: 'habit_id = ?', whereArgs: [habitId]);
  await db.delete('habits', where: 'id = ?', whereArgs: [habitId]);
}
}