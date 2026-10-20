import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  DatabaseService._();
  static final DatabaseService instance = DatabaseService._();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'car_care.db');
    return openDatabase(
      path,
      version: 2,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE fuel_entries(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            station TEXT NOT NULL,
            organization TEXT NOT NULL,
            date TEXT NOT NULL,
            fuelType TEXT NOT NULL,
            amount REAL NOT NULL,
            price REAL NOT NULL,
            totalCost REAL NOT NULL,
            mileage INTEGER,
            car_id INTEGER,
            FOREIGN KEY (car_id) REFERENCES cars(id) ON DELETE CASCADE
          )
        ''');
        await db.execute('''
          CREATE TABLE cars(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            imgPath TEXT,
            fuelType TEXT NOT NULL,
            mileage INTEGER NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE maintenance_reminders(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            carId INTEGER NOT NULL,
            title TEXT NOT NULL,
            category TEXT NOT NULL,
            reminderType TEXT NOT NULL,
            dueM INTEGER,
            dueD TEXT,
            repeatByM INTEGER NOT NULL DEFAULT 0,
            intervalM INTEGER,
            repeatByD INTEGER NOT NULL DEFAULT 0,
            intervalD INTEGER,
            FOREIGN KEY (carId) REFERENCES cars(id) ON DELETE CASCADE
          )
        ''');
        await db.execute('''
          CREATE TABLE maintenance_history(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            carId INTEGER NOT NULL,
            reminderId INTEGER,
            title TEXT NOT NULL,
            category TEXT NOT NULL,
            date TEXT NOT NULL,
            mileage INTEGER NOT NULL,
            cost REAL,
            comment TEXT,
            FOREIGN KEY (carId) REFERENCES cars(id) ON DELETE CASCADE
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            ALTER TABLE fuel_entries
            ADD COLUMN car_id INTEGER REFERENCES cars(id) ON DELETE CASCADE
          ''');
          await db.execute('''
            UPDATE fuel_entries
            SET car_id = (SELECT id FROM cars ORDER BY id LIMIT 1)
            WHERE car_id IS NULL
          ''');
        }
      },
      onDowngrade: onDatabaseDowngradeDelete,
    );
  }
}
