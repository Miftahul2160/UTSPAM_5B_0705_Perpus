
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/user.dart';

class DBHelper {
  static const String dbname = 'library.db';
  DBHelper._init();
  static final DBHelper instance = DBHelper._init();
  static Database? _database;


  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(dbname);
    return _database!;
  }

  Future<Database> _initDB(String dbName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    // Membuat tabel pengguna
    await db.execute('''
      CREATE TABLE ${User.tableUser} (
        ${User.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${User.columnNama} TEXT NOT NULL,
        ${User.columnNik} INTEGER NOT NULL,
        ${User.columnEmail} TEXT UNIQUE NOT NULL,
        ${User.columAlamat} TEXT NOT NULL,
        ${User.columnUsername} TEXT UNIQUE NOT NULL,
        ${User.columnNoTelp} INTEGER NOT NULL,
        ${User.columnPassword} TEXT NOT NULL
      )
    ''');

    // TODO: Tambahkan tabel 'Buku' dan 'Transaksi' di sini.
  }
  
  // --- FUNGSI UTAMA AUTENTIKASI ---
  Future<User?> authenticate(String identifier, String password) async {
    final db = await database;
    
    // Identifier bisa berupa Email atau NIK
    final List<Map<String, dynamic>> maps = await db.query(
      User.tableUser,
      where: '(${User.columnEmail} = ? OR ${User.columnNik} = ?) AND ${User.columnPassword} = ?',
      whereArgs: [identifier, identifier, password],
    );

    if (maps.isNotEmpty) {
      // Jika ditemukan, kembalikan objek User
      return User.fromMap(maps.first);
    }
    
    // Jika tidak ditemukan
    return null;
  }
  
  // TODO: Tambahkan fungsi insertUser untuk Registrasi.
}