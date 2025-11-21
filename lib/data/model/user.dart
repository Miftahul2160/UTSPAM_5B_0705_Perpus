class User {
  static const String tableUser = 'users';
  static const String columnId = '_id';
  static const String columnNama = 'nama';
  static const String columnUsername = 'username';
  static const String columnNoTelp = 'no_telp';
  static const String columAlamat = 'alamat';
  static const String columnNik = 'nik';
  static const String columnEmail = 'email';
  static const String columnPassword = 'password';

  int? id;
  String nama;
  String nik;
  String? alamat;
  String username; 
  String? noTelp;
  String email;
  String password;
  
  User({
    this.id,
    required this.nama,
    required this.nik,
    required this.email,
    required this.password,
    required this.username,
    this.alamat,
    this.noTelp,
  });

  // Konversi Objek User menjadi Map (untuk disimpan di SQFLite)
  Map<String, dynamic> toMap() {
    return {
      columnNama: nama,
      columnNik: nik,
      columnEmail: email,
      columAlamat: alamat,
      columnUsername: username,
      columnNoTelp: noTelp,
      columnPassword: password,
      // id tidak disertakan karena biasanya diatur otomatis oleh DB
    };
  }

  // Membuat Objek User dari Map (untuk dibaca dari SQFLite)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map[columnId],
      nama: map[columnNama],
      nik: map[columnNik],
      email: map[columnEmail],
      alamat: map[columAlamat],
      username: map[columnUsername],
      noTelp: map[columnNoTelp],
      password: map[columnPassword],
    );
  }
}