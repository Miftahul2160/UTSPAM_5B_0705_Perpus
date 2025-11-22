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