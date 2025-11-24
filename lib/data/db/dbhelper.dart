import 'package:sqflite/sqflite.dart' hide Transaction;
import 'package:path/path.dart';
import '../model/user.dart';
import '../model/transaction.dart';
import '../model/book.dart';

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

  Future<Database> _initDB(String dbname) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbname);
    return await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: (db, oldVersion, newVersion) async {
        // Simple upgrade for development: drop and recreate tables.
        // WARNING: this will erase existing data. Remove/change for production.
        await db.execute('DROP TABLE IF EXISTS ${User.tableUser}');
        await db.execute(
          'DROP TABLE IF EXISTS ${Transaction.tableTransaction}',
        );
        await db.execute('DROP TABLE IF EXISTS ${Book.tableBook}');
        await _onCreate(db, newVersion);
      },
    );
  }

  Future _onCreate(Database db, int version) async {
    // Membuat tabel pengguna
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${User.tableUser} (
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

    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${Transaction.tableTransaction} (
        ${Transaction.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${Transaction.columnJudulBuku} TEXT NOT NULL,
        ${Transaction.columnNamaPeminjam} TEXT NOT NULL,
        ${Transaction.columnDurasiPinjam} INTEGER NOT NULL,
        ${Transaction.columnTanggalPinjam} TEXT NOT NULL,
        ${Transaction.columnTotalBiaya} REAL NOT NULL,
        ${Transaction.columnStatus} TEXT NOT NULL
      )
    ''');

    await insertBooks(dummyBooks);
    // Tabel buku
    await db.execute('''
      CREATE TABLE IF NOT EXISTS books (
        ${Book.columnId} INTEGER PRIMARY KEY,
        ${Book.columnCover} TEXT NOT NULL,
        ${Book.columnJudul} TEXT NOT NULL,
        ${Book.columnGenre} TEXT NOT NULL,
        ${Book.columnHargaPinjam} REAL NOT NULL,
        ${Book.columnSinopsis} TEXT NOT NULL
      )
    ''');
  }

  // --- FUNGSI UTAMA AUTENTIKASI ---
  Future<User?> authenticate(String identifier, String password) async {
    final db = await database;

    // Identifier bisa berupa Email atau NIK
    // Jika identifier dapat diparse jadi int, kirim sebagai int untuk NIK
    final int? nikValue = int.tryParse(identifier);
    final whereArgs = nikValue != null
        ? [identifier, nikValue, password]
        : [identifier, identifier, password];
    final List<Map<String, dynamic>> maps = await db.query(
      User.tableUser,
      where:
          '(${User.columnEmail} = ? OR ${User.columnNik} = ?) AND ${User.columnPassword} = ?',
      whereArgs: whereArgs,
    );
    if (maps.isNotEmpty) {
      // Jika ditemukan, kembalikan objek User
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateTransactionStatus(int id, String newStatus) async {
    final db = await database;

    // Map yang hanya berisi kolom yang ingin diubah
    final updateMap = {Transaction.columnStatus: newStatus};

    // Melakukan UPDATE di SQFLite
    return await db.update(
      Transaction.tableTransaction,
      updateMap,
      where: '${Transaction.columnId} = ?',
      whereArgs: [id],
    );
  }

  // Insert user untuk registrasi
  // Mengembalikan id baris yang diinsert (>=1) jika sukses, atau 0 jika gagal
  Future<int> insertUser(User user) async {
    final db = await database;
    try {
      return await db.insert(
        User.tableUser,
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    } on DatabaseException catch (e) {
      print('gagal insert user: $e');
      // Jika terjadi pelanggaran constraint (mis. UNIQUE), laporkan 0 sebagai gagal
      final err = e.toString();
      if (err.contains('UNIQUE') || err.contains('unique')) {
        return 0;
      }
      rethrow;
    } catch (e) {
      return 0;
    }
  }

  // Debug helper: ambil semua user yang tersimpan (berguna untuk pemeriksaan)
  Future<List<User>> getAllUsers() async {
    final db = await database;
    final maps = await db.query(User.tableUser);
    return maps.map((m) => User.fromMap(m)).toList();
  }

  Future<int> insertTransaction(Transaction transaction) async {
    final db = await database;
    // Pastikan toMap sudah dikonversi dengan benar (DateTime ke String)
    return await db.insert(
      Transaction.tableTransaction,
      transaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // --- FUNGSI BARU: GET ALL TRANSACTIONS (READ) ---
  Future<List<Transaction>> getAllTransactions() async {
    final db = await database;

    // Mengambil semua baris, diurutkan berdasarkan ID terbaru
    final List<Map<String, dynamic>> maps = await db.query(
      Transaction.tableTransaction,
      orderBy: '${Transaction.columnId} DESC',
    );

    // Konversi List<Map> menjadi List<Transaction>
    return List.generate(maps.length, (i) {
      // Perhatikan: Kita perlu mengabaikan coverUrl karena tidak disimpan di DB
      return Transaction.fromMap(maps[i]);
    });
  }

  // --- UPDATE TRANSAKSI LENGKAP ---
  Future<int> updateTransaction(Transaction transaction) async {
    final db = await database;

    // Menggunakan toMap(), pastikan ID tidak termasuk agar tidak ter-update
    final updateMap = transaction.toMap();

    return await db.update(
      Transaction.tableTransaction,
      updateMap,
      where: '${Transaction.columnId} = ?',
      whereArgs: [transaction.id],
    );
  }

  // ----------------- BOOK CRUD & SEEDING -----------------
  Future<int> insertBook(Book book) async {
    final db = await database;
    return await db.insert(
      Book.tableBook,
      book.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> insertBooks(List<Book> books) async {
    final db = await database;
    final batch = db.batch();
    for (final b in books) {
      batch.insert(Book.tableBook, b.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
    return books.length;
  }

  Future<List<Book>> getAllBooks() async {
    final db = await database;
    final maps = await db.query(Book.tableBook, orderBy: '${Book.columnId} ASC');
    return maps.map((m) => Book.fromMap(m)).toList();
  }

  /// Jika tabel buku kosong, masukkan data dari `dummyBooks`.
  Future<void> seedDummyBooks() async {
    final db = await database;
    final List<Map<String, Object?>> countResult =
        await db.rawQuery('SELECT COUNT(*) as cnt FROM ${Book.tableBook}');
    final int count = countResult.isNotEmpty
        ? (countResult.first['cnt'] is int
            ? countResult.first['cnt'] as int
            : int.parse(countResult.first['cnt'].toString()))
        : 0;
    if (count == 0) {
      await insertBooks(dummyBooks);
    }
  }
  
}
