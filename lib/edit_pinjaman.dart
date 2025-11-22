import 'package:flutter/material.dart';
import 'package:flutter_library/data/model/transaction.dart';

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
  String _status = 'Aktif';

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.transaction.namaPeminjam);
    _durasiController = TextEditingController(text: widget.transaction.durasiPinjam.toString());
    _status = widget.transaction.status;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _durasiController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final updatedNama = _namaController.text.trim();
    final updatedDurasi = int.tryParse(_durasiController.text.trim()) ?? widget.transaction.durasiPinjam;

    final updated = Transaction(
      id: widget.transaction.id,
      judulBuku: widget.transaction.judulBuku,
      namaPeminjam: updatedNama,
      durasiPinjam: updatedDurasi,
      tanggalPinjam: widget.transaction.tanggalPinjam,
      totalBiaya: widget.transaction.totalBiaya,
      status: _status,
    );

    Navigator.pop(context, updated);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Edit Berhasil! Data diperbarui.')));
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
                  controller: _namaController,
                  decoration: const InputDecoration(labelText: 'Nama Peminjam'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Nama tidak boleh kosong' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _durasiController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Durasi Pinjam (hari)'),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Durasi tidak boleh kosong';
                    final n = int.tryParse(v.trim());
                    if (n == null || n <= 0) return 'Masukkan durasi valid';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _status,
                  decoration: const InputDecoration(labelText: 'Status'),
                  items: const [
                    DropdownMenuItem(value: 'Aktif', child: Text('Aktif')),
                    DropdownMenuItem(value: 'Selesai', child: Text('Selesai')),
                    DropdownMenuItem(value: 'Dibatalkan', child: Text('Dibatalkan')),
                  ],
                  onChanged: (v) => setState(() {
                    if (v != null) _status = v;
                  }),
                ),
                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: _save,
                  child: const Text('Simpan Perubahan'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
