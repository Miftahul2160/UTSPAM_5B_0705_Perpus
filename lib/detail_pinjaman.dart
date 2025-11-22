import 'package:flutter/material.dart';
import 'package:flutter_library/edit_pinjaman.dart';
import 'package:flutter_library/menu/menu_historybooks.dart';
// import 'data/model/book.dart';

import 'data/model/transaction.dart';
import 'package:intl/intl.dart';

class DetailPinjaman extends StatefulWidget {
  final Transaction transaction;
  const DetailPinjaman({super.key, required this.transaction});

  @override
  State<DetailPinjaman> createState() => _DetailPinjamanState();
}

class _DetailPinjamanState extends State<DetailPinjaman> {
  late Transaction _currentTransaction;
  @override
  void initState() {
    super.initState();
    _currentTransaction = widget.transaction;
  }
  void _cancelPinjaman() {
    // Tombol untuk membatalkan pinjam (cancel)
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Pembatalan"),
        content: const Text("Apakah Anda yakin ingin membatalkan peminjaman ini?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("TIDAK")),
          TextButton(
            onPressed: () {
              // TODO: Update status di database SQFLite menjadi 'Dibatalkan'
              setState(() {
                _currentTransaction.status = 'Dibatalkan';
              });
              Navigator.pop(context); // Tutup dialog
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Peminjaman telah Dibatalkan.')),
              );
            },
            child: const Text("YA, BATALKAN", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _goToEditPinjaman() async {
    // Tombol edit, hanya muncul jika status 'Aktif'
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Editpinjaman(transaction: _currentTransaction),
      ),
    );
    // Setelah kembali dari Halaman Edit, refresh data (asumsikan data di DB sudah diperbarui)
    // TODO: Panggil fungsi untuk mengambil data terbaru dari DB
    setState(() {
      // Untuk demo, kita hanya refresh status widget
    });
  }

  void _backToHistory() {
    // Tombol untuk kembali ke riwayat sewa (Menutup halaman detail)
    // Navigator.pop(context); // Jika HistoryPage sudah merupakan halaman sebelumnya
    
    // Sesuai ketentuan, kembali ke Riwayat Sewa dan memperbarui data histori
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => MenuHistoryBook()),
    );
  }

Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey)),
          ),
          const Text(': ', style: TextStyle(fontWeight: FontWeight.w500)),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontWeight: FontWeight.w600, color: valueColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Peminjaman'),
        // Tombol kembali yang menutup halaman detail
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _backToHistory,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // --- Bagian Status ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _currentTransaction.judulBuku,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Chip(
                  label: Text(
                    _currentTransaction.status,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: _currentTransaction.status == 'Aktif' ? Colors.green : Colors.red,
                ),
              ],
            ),
            const Divider(height: 30),

            // --- Cover Buku (Placeholder) ---
            Center(
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(Icons.book, size: 96, color: Colors.grey[600]),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- Rincian Data Transaksi ---
            const Text('Rincian Transaksi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _buildDetailRow('Judul Buku', _currentTransaction.judulBuku),
            _buildDetailRow('Nama Peminjam', _currentTransaction.namaPeminjam),
            _buildDetailRow('Lama Pinjam', '${_currentTransaction.durasiPinjam} Hari'),
            _buildDetailRow(
              'Tanggal Mulai',
              DateFormat('dd MMMM yyyy').format(_currentTransaction.tanggalPinjam),
            ),
            _buildDetailRow(
              'Total Biaya',
              formatter.format(_currentTransaction.totalBiaya),
              valueColor: Theme.of(context).primaryColor,
            ),

            const SizedBox(height: 40),

            // --- Tombol Aksi ---
            if (_currentTransaction.status == 'Aktif') ...[
              // Tombol Edit Sewa (Hanya muncul jika pesanan masih aktif)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _goToEditPinjaman,
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Sewa'),
                ),
              ),
              const SizedBox(height: 10),

              // Tombol Batalkan Pinjam
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _cancelPinjaman,
                  icon: const Icon(Icons.cancel, color: Colors.red),
                  label: const Text('Batalkan Pinjam (Cancel)', style: TextStyle(color: Colors.red)),
                ),
              ),
            ],
            
            // Tombol kembali ke riwayat (selalu ada, atau bisa menggunakan leading AppBar)
            const SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: _backToHistory,
                child: const Text('Kembali ke Riwayat Sewa', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}