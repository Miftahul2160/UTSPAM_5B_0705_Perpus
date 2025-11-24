class Transaction {
  static const String tableTransaction = 'transactions';
  static const String columnId = '_id';
  static const String columnJudulBuku = 'judul_buku';
  static const String columnNamaPeminjam = 'nama_peminjam';
  static const String columnDurasiPinjam = 'durasi_pinjam';
  static const String columnTanggalPinjam = 'tanggal_pinjam';
  static const String columnTotalBiaya = 'total_biaya';
  static const String columnStatus = 'status';
  
  int? id;
  String judulBuku;
  String namaPeminjam;
  int durasiPinjam;
  DateTime tanggalPinjam;
  double totalBiaya;
  String status;

  Transaction({
    this.id,
    required this.judulBuku,
    required this.namaPeminjam,
    required this.durasiPinjam,
    required this.tanggalPinjam,
    required this.totalBiaya,
    this.status = 'Aktif',
}
  );

  // Konversi Objek Transaction menjadi Map (untuk disimpan di SQFLite)
  Map<String, dynamic> toMap() {
    return {
      columnJudulBuku: judulBuku,
      columnNamaPeminjam: namaPeminjam,
      columnDurasiPinjam: durasiPinjam,
      columnTanggalPinjam: tanggalPinjam.toIso8601String(),
      columnTotalBiaya: totalBiaya,
      columnStatus: status,
      };
  }

factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map[columnId],
      judulBuku: map[columnJudulBuku].toString(),
      namaPeminjam: map[columnNamaPeminjam].toString(),
      durasiPinjam: map[columnDurasiPinjam] is int ? map[columnDurasiPinjam] as int : int.parse(map[columnDurasiPinjam].toString()),
      tanggalPinjam: DateTime.parse(map[columnTanggalPinjam].toString()),
      totalBiaya: (map[columnTotalBiaya] is double)
          ? map[columnTotalBiaya] as double
          : double.parse(map[columnTotalBiaya].toString()),
      status: map[columnStatus].toString()
    );
  }
}