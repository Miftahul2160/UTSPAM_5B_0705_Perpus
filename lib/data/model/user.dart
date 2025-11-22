import 'dart:convert';
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
  int nik;
  String? alamat;
  String username; 
  int? noTelp;
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
      nik: map[columnNik] is int
          ? map[columnNik] as int
          : int.parse(map[columnNik].toString()),
      email: map[columnEmail],
      alamat: map[columAlamat],
      username: map[columnUsername],
      noTelp: map[columnNoTelp] == null
          ? null
          : (map[columnNoTelp] is int
              ? map[columnNoTelp] as int
              : int.parse(map[columnNoTelp].toString())),
      password: map[columnPassword],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User{id: $id, nama: $nama, nik: $nik, email: $email, alamat: $alamat, username: $username, noTelp: $noTelp}';
  }


}