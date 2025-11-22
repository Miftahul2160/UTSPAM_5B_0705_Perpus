import 'package:flutter/material.dart';
import 'package:flutter_library/data/db/dbhelper.dart';
import 'package:flutter_library/data/model/transaction.dart';
import 'package:intl/intl.dart';

class Editpinjaman extends StatefulWidget {
  final Transaction transaction;

  const Editpinjaman({super.key, required this.transaction});

  @override
  State<Editpinjaman> createState() => _EditpinjamanState();
}

class _EditpinjamanState extends State<Editpinjaman> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _durasiController;
  late DateTime _tanggalMulai;
  late double _totalBiaya;
  final double _hargaPerHari = 5000;
  String _status = 'Aktif';

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.transaction.namaPeminjam);
    _durasiController = TextEditingController(text: widget.transaction.durasiPinjam.toString());
    _tanggalMulai = widget.transaction.tanggalPinjam;
    _totalBiaya = widget.transaction.totalBiaya;
    _status = widget.transaction.status;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _durasiController.dispose();
    super.dispose();
  }

  void _calculateTotal() {
    int hari = int.tryParse(_durasiController.text) ?? 0;
    setState(() {
      _totalBiaya = hari * _hargaPerHari;
    });
  }

  Future<void> _handleSave() async {
    if (_formKey.currentState!.validate()) {
      // 1. Buat objek Transaksi yang diperbarui
      final updatedTransaction = Transaction(
        id: widget.transaction.id,
        judulBuku: widget.transaction.judulBuku,
        namaPeminjam: _namaController.text.trim(),
        durasiPinjam: int.parse(_durasiController.text),
        tanggalPinjam: _tanggalMulai,
        totalBiaya: _totalBiaya,
        status: _status, // gunakan status yang dipilih
      );

      // 2. Panggil fungsi update SQFLite
      int rowsAffected = await DBHelper.instance.updateTransaction(updatedTransaction);
      
      if (rowsAffected > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Penyewaan berhasil diubah dan data histori diperbarui.')),
        );
        // 3. Kembali ke Halaman Detail Peminjaman (mengirim sinyal update)
        Navigator.pop(context, true); 
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menyimpan perubahan.'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Pinjaman')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Mengedit Transaksi ID: ${widget.transaction.id}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text('Buku: ${widget.transaction.judulBuku}'),
                const SizedBox(height: 20),

                // Line ~25: edit form starts here
                
                TextFormField(
                  controller: _durasiController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Durasi Pinjam (hari)'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Durasi tidak boleh kosong';
                    final n = int.tryParse(value.trim());
                    if (n == null || n <= 0) return 'Masukkan durasi valid';
                    return null;
                  },
                  onChanged: (_) => _calculateTotal(),
                ),
                const SizedBox(height: 12),
                ListTile(
                title: const Text('Tanggal Mulai Pinjam'),
                subtitle: Text(DateFormat('dd MMMM yyyy').format(_tanggalMulai)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _tanggalMulai,
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2027),
                  );
                  if (picked != null) {
                    setState(() {
                      _tanggalMulai = picked;
                      // Total biaya dihitung ulang jika tanggal mulai memengaruhi durasi, tapi disini diabaikan
                    });
                  }
                },
              ),
              const SizedBox(height: 25),

              // Total Biaya
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Biaya Pinjam:', style: TextStyle(fontSize: 18)),
                      Text('Rp ${_totalBiaya.toStringAsFixed(0)}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Tombol Simpan
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleSave,
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text('Simpan Perubahan', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
