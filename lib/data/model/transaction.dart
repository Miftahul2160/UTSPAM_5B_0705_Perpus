class Transaction {
  final int id;
  final String judulBuku;
  final String namaPeminjam;
  final int durasiPinjam;
  final DateTime tanggalPinjam;
  final double totalBiaya;
  String status;

  Transaction({
    required this.id,
    required this.judulBuku,
    required this.namaPeminjam,
    required this.durasiPinjam,
    required this.tanggalPinjam,
    required this.totalBiaya,
    this.status = 'Aktif',
  }); 

factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      judulBuku: map['judul_buku'],
      namaPeminjam: map['nama_peminjam'],
      durasiPinjam: map['durasi_pinjam'],
      tanggalPinjam: DateTime.parse(map['tanggal_pinjam']),
      totalBiaya: map['total_biaya'],
      status: map['status'],
    );
  }
}