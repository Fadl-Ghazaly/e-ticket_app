import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const String _dbName = 'eticketing.db';
  static const int _dbVersion = 1;
  
  // UBAH INI: Hapus underscore agar bisa diakses dari luar
  static const String tableBookings = 'bookings'; // Sekarang public

  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(_dbName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: _dbVersion, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableBookings (  // Gunakan tableBookings tanpa underscore
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        ticketId TEXT NOT NULL,
        ticketTitle TEXT NOT NULL,
        price TEXT NOT NULL,
        imageUrl TEXT NOT NULL,
        bookingDate TEXT NOT NULL,
        status TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertBooking(Map<String, dynamic> booking) async {
    final db = await instance.database;
    return await db.insert(tableBookings, booking); // Gunakan tableBookings tanpa underscore
  }

  Future<List<Map<String, dynamic>>> getAllBookings() async {
    final db = await instance.database;
    return await db.query(tableBookings); // Gunakan tableBookings tanpa underscore
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}