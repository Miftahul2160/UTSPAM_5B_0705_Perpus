import 'package:flutter/material.dart';
import 'package:flutter_library/data/model/transaction.dart';
import 'package:flutter_library/data/db/dbhelper.dart';
import 'package:flutter_library/detail_pinjaman.dart';

class MenuHistoryBook extends StatefulWidget {
  const MenuHistoryBook({super.key});

  @override
  State<MenuHistoryBook> createState() => _MenuHistoryBookState();
}

class _MenuHistoryBookState extends State<MenuHistoryBook> {
  late Future<List<Transaction>> _transactionsFuture;

  @override
  void initState() {
    super.initState();
    // Panggil fungsi READ data dari database
    _transactionsFuture = DBHelper.instance.getAllTransactions();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Pinjam Buku')),
      body: FutureBuilder<List<Transaction>>(
        future: _transactionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error memuat data: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Anda belum memiliki riwayat peminjaman.'));
          }

          final transactions = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaksi = transactions[index];
              return Card(
                // ... (Kode Card & ListTile sebelumnya) ...
                child: ListTile(
                  leading: const Icon(Icons.menu_book, size: 40),
                  title: Text(transaksi.judulBuku, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Peminjam: ${transaksi.namaPeminjam}'),
                      Text('Total Biaya: Rp ${transaksi.totalBiaya.toStringAsFixed(0)}'),
                    ],
                  ),
                  trailing: Chip(
                    label: Text(transaksi.status, style: const TextStyle(color: Colors.white)),
                    backgroundColor: transaksi.status == 'Aktif' ? Colors.green : Colors.red,
                  ),
                  onTap: () {
                    // Navigasi ke Halaman Detail Peminjaman
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPinjaman(transaction: transaksi),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}