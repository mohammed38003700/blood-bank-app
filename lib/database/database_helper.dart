import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/donor.dart';
import '../models/blood_request.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'blood_bank.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE donors (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        bloodType TEXT NOT NULL,
        phone TEXT NOT NULL,
        city TEXT NOT NULL,
        lastDonation INTEGER NOT NULL,
        isAvailable INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE blood_requests (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        patientName TEXT NOT NULL,
        bloodType TEXT NOT NULL,
        hospital TEXT NOT NULL,
        city TEXT NOT NULL,
        unitsNeeded INTEGER NOT NULL,
        unitsReceived INTEGER NOT NULL,
        contactPhone TEXT NOT NULL,
        requestDate INTEGER NOT NULL,
        isUrgent INTEGER NOT NULL,
        status TEXT NOT NULL
      )
    ''');
  }

  // عمليات المتبرعين
  Future<int> insertDonor(Donor donor) async {
    final db = await database;
    return await db.insert('donors', donor.toMap());
  }

  Future<List<Donor>> getDonors() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('donors');
    return List.generate(maps.length, (i) => Donor.fromMap(maps[i]));
  }

  Future<List<Donor>> getDonorsByBloodType(String bloodType) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'donors',
      where: 'bloodType = ? AND isAvailable = 1',
      whereArgs: [bloodType],
    );
    return List.generate(maps.length, (i) => Donor.fromMap(maps[i]));
  }

  Future<int> updateDonor(Donor donor) async {
    final db = await database;
    return await db.update(
      'donors',
      donor.toMap(),
      where: 'id = ?',
      whereArgs: [donor.id],
    );
  }

  Future<int> deleteDonor(int id) async {
    final db = await database;
    return await db.delete(
      'donors',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // عمليات طلبات الدم
  Future<int> insertBloodRequest(BloodRequest request) async {
    final db = await database;
    return await db.insert('blood_requests', request.toMap());
  }

  Future<List<BloodRequest>> getBloodRequests() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('blood_requests');
    return List.generate(maps.length, (i) => BloodRequest.fromMap(maps[i]));
  }

  Future<int> updateBloodRequest(BloodRequest request) async {
    final db = await database;
    return await db.update(
      'blood_requests',
      request.toMap(),
      where: 'id = ?',
      whereArgs: [request.id],
    );
  }

   Future<int> deletblood(int id) async {
    final db = await database;
    return await db.delete(
      'blood_requests',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}