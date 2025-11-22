import 'package:flutter/material.dart';
import 'package:flutter_library/data/model/book.dart';
import 'package:flutter_library/data/model/user.dart';
import 'package:flutter_library/peminjaman.dart';

class MenuHome extends StatefulWidget {
  const MenuHome({super.key, required User activeUser});

  @override
  State<MenuHome> createState() => _MenuHomeState();
}

class _MenuHomeState extends State<MenuHome> {
  @override
  Widget build(BuildContext context) {
    final books = dummyBooks;
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Buku Rekomendasi')),
      body: GridView.builder(
        padding: const EdgeInsets.all(10.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Menampilkan 2 kolom
          childAspectRatio: 0.65, // Rasio lebar/tinggi kartu
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return _buildBookCard(context, book);
        },
      ),
    );
  }

  _buildBookCard(BuildContext context, Book book) {
    return InkWell(
      onTap: () {
        _showSynopsisDialog(context, book);
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                child: Image.asset(book.coverImage, fit: BoxFit.cover),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.judul,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'by ${book.hargaPinjam.toStringAsFixed(0)}/hari',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PeminjamanPage(selectedBook: book),
                    ),
                  );
                },
                child: const Text('Pinjam'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSynopsisDialog(BuildContext context, Book book) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            book.judul,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(book.genre, style: TextStyle(color: Colors.grey.shade600)),
                const SizedBox(height: 10),
                const Text(
                  'Sinopsis Singkat:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(book.sinopsis), // Menampilkan sinopsis
                const SizedBox(height: 15),
                Text(
                  'Harga Pinjam: Rp ${book.hargaPinjam.toStringAsFixed(0)}/hari',
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('TUTUP'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('PINJAM BUKU'),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PeminjamanPage(selectedBook: book),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
