class Book {
  final int id;
  final String coverImage;
  final String judul;
  final String genre;
  final double hargaPinjam;
  final String sinopsis;

  Book({
    required this.id,
    required this.coverImage,
    required this.judul,
    required this.genre,
    required this.hargaPinjam,
    required this.sinopsis,
  });

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      coverImage: map['cover'],
      judul: map['judul'],
      genre: map['genre'],
      hargaPinjam: map['harga_pinjam'],
      sinopsis: map['sinopsis'],
    );
  }
  
}

final List<Book> dummyBooks = [
  Book(id: 1, judul: 'Filosofi Teras', genre: 'Filsafat', hargaPinjam: 5000.0, coverImage:'assets/images/coverFilosofiTeras.png', sinopsis: 'Sebuah buku pengantar filsafat Stoa yang dibuat khusus sebagai panduan moral anak muda.'),
  Book(id: 2, judul: 'Bumi', genre: 'Fantasi', hargaPinjam: 3000.0, coverImage:'assets/images/coverBumi.png', sinopsis: 'Serial ini mengikuti petualangan tiga sahabat, Raib, Seli, dan Ali, yang menemukan dunia paralel dengan teknologi mutakhir, berbeda dengan genre fantasi seperti Harry Potter.'),
  Book(id: 3, judul: 'Negeri Para Bedebah', genre: 'Komik', hargaPinjam: 4500.0, coverImage:'assets/images/coverNegeriParaBedebah.png', sinopsis: 'Berkisah tentang Thomas, seorang konsultan keuangan brilian yang harus berjuang membersihkan nama baik keluarganya di tengah skandal besar yang mengguncang negeri.'),
];