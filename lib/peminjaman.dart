import 'package:flutter/material.dart';
import 'package:flutter_library/data/model/book.dart';

class PeminjamanPage extends StatefulWidget {
  final Book? selectedBook;
  const PeminjamanPage({Key? key, this.selectedBook}) : super(key: key);


  @override
  State<PeminjamanPage> createState() => _PeminjamanPageState();
}

class _PeminjamanPageState extends State<PeminjamanPage> {
  String get _judulBuku => widget.selectedBook?.judul ?? 'Tidak ada buku yang dipilih';
  double get _hargaPerHari => widget.selectedBook?.hargaPinjam ?? 0.0;
  
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}