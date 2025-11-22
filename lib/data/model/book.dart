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
  Book(id: 1, judul: 'Flutter Fundamentals', genre: 'Technology', hargaPinjam: 5000.0, coverImage:'https://images.unsplash.com/photo-1517058611140-5e5d3c8a91a9?fit=crop&w=300&q=80', sinopsis: 'Dasar-dasar pembuatan aplikasi mobile.'),
  Book(id: 2, judul: 'Clean Code', genre: 'Software Engineering', hargaPinjam: 7500.0, coverImage:'https://images.unsplash.com/photo-1543818318-7f551c91c3e3?fit=crop&w=300&q=80', sinopsis: 'Panduan menulis kode yang bersih dan mudah dipelihara.'),
  Book(id: 3, judul: 'The 7 Habits', genre: 'Self-Improvement', hargaPinjam: 4500.0, coverImage:'https://images.unsplash.com/photo-1601327159757-5e9a4f4d2f00?fit=crop&w=300&q=80', sinopsis: 'Kebiasaan efektif untuk kehidupan pribadi dan profesional.'),
];