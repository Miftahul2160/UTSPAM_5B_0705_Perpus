// file: lib/screens/peminjaman_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_library/data/model/book.dart';
import 'package:flutter_library/data/model/transaction.dart';
import 'package:flutter_library/data/db/dbhelper.dart';
import 'package:flutter_library/menu/menu_historybooks.dart';
import 'package:flutter_library/data/model/user.dart';

class PeminjamanPage extends StatefulWidget {
  final Book? selectedBook;
  // Properti untuk menerima objek user yang sedang login
  final User loggedInUser;

  const PeminjamanPage({
    Key? key,
    this.selectedBook,
    required this.loggedInUser,
  }) : super(key: key);

  @override
  _PeminjamanPageState createState() => _PeminjamanPageState();
}

class _PeminjamanPageState extends State<PeminjamanPage> {
  final _formKey = GlobalKey<FormState>();
  final _lamaPinjamController = TextEditingController();
  
  // Variabel untuk menyimpan objek user yang login
  late User _user; // User akan diinisialisasi di initState
  
  DateTime? _tanggalMulai;
  double _totalBiaya = 0;
  bool _isLoading = false;

  String get _judulBuku => widget.selectedBook?.judul ?? "Buku Tidak Diketahui";
  double get _hargaPerHari => widget.selectedBook?.hargaPinjam ?? 0;

  @override
  void initState() {
    super.initState();
    // Ambil data user dari widget yang di-pass
    _user = widget.loggedInUser; 
    
    _tanggalMulai = DateTime.now();
    _lamaPinjamController.addListener(_calculateTotal);
  }

  @override
  void dispose() {
    _lamaPinjamController.removeListener(_calculateTotal);
    _lamaPinjamController.dispose();
    super.dispose();
  }

  void _calculateTotal() {
    int hari = int.tryParse(_lamaPinjamController.text) ?? 0;
    setState(() {
      _totalBiaya = hari * _hargaPerHari;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _tanggalMulai ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2027),
    );
    if (picked != null && picked != _tanggalMulai) {
      setState(() {
        _tanggalMulai = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (widget.selectedBook == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Tidak ada buku yang dipilih.', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red),
      );
      return;
    }
    
    if (_formKey.currentState!.validate() && _tanggalMulai != null) {
      setState(() {
        _isLoading = true;
      });

      // 1. Buat objek Transaksi baru
      final newTransaction = Transaction(
        judulBuku: _judulBuku,
        namaPeminjam: _user.nama,
        durasiPinjam: int.parse(_lamaPinjamController.text),
        tanggalPinjam: _tanggalMulai!,
        totalBiaya: _totalBiaya,
        status: 'Aktif',
      );

      try {
        debugPrint('Attempting to insert transaction: $newTransaction');
        final newId = await DBHelper.instance.insertTransaction(newTransaction);
        debugPrint('Insert returned id: $newId');

        if (newId > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Peminjaman berhasil disimpan!')),
          );
          // Navigasi ke Halaman Riwayat Sewa
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MenuHistoryBook()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal menyimpan transaksi ke database.'), backgroundColor: Colors.red),
          );
        }
      } catch (e, st) {
        debugPrint('Error inserting transaction: $e');
        debugPrint(st.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi error: $e'), backgroundColor: Colors.red),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua kolom dan tanggal wajib diisi!'), backgroundColor: Colors.orange),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formulir Peminjaman')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // --- Detail Buku ---
              ListTile(
                leading: widget.selectedBook != null && widget.selectedBook!.coverImage.isNotEmpty
                  ? Image.asset(widget.selectedBook!.coverImage, width: 50, fit: BoxFit.cover)
                  : const Icon(Icons.menu_book, size: 40),
                title: Text(_judulBuku, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Harga per hari: Rp ${_hargaPerHari.toStringAsFixed(0)}'),
              ),
              const Divider(),

              // Nama Peminjam (Otomatis dari objek user yang login)
              Text(
                'Nama Peminjam: ${_user.nama}', 
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey),
              ),
              const SizedBox(height: 15),

              // Lama Pinjam
              TextFormField(
                controller: _lamaPinjamController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Lama Pinjam (hari)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lama pinjam wajib diisi.';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Lama pinjam harus berupa angka positif.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // Tanggal Mulai Pinjam
              ListTile(
                title: const Text('Tanggal Mulai Pinjam'),
                subtitle: Text(
                  _tanggalMulai == null 
                      ? 'Pilih Tanggal' 
                      : DateFormat('dd MMMM yyyy').format(_tanggalMulai!),
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),

              const SizedBox(height: 25),

              // --- Total Biaya ---
              Card(
                color: Colors.blue.shade50,
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Biaya Pinjam:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
                      Text(
                        'Rp ${_totalBiaya.toStringAsFixed(0)}', 
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue.shade700)
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Tombol Submit
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('PINJAM SEKARANG', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}