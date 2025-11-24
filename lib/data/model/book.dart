class Book {
  static const String tableBook = 'books';
  static const String columnId = 'id';
  static const String columnCover = 'cover';
  static const String columnJudul = 'judul';
  static const String columnGenre = 'genre';
  static const String columnHargaPinjam = 'harga_pinjam';
  static const String columnSinopsis = 'sinopsis';

  int id;
  String coverImage;
  String judul;
  String genre;
  double hargaPinjam;
  String sinopsis;

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
      id: map[columnId],
      coverImage: map[columnCover],
      judul: map[columnJudul],
      genre: map[columnGenre],
      hargaPinjam: map[columnHargaPinjam] as double,
      sinopsis: map[columnSinopsis],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      columnId: id,
      columnCover: coverImage,
      columnJudul: judul,
      columnGenre: genre,
      columnHargaPinjam: hargaPinjam,
      columnSinopsis: sinopsis,
    };
  }
}

final List<Book> dummyBooks = [
  Book(
    id: 1,
    judul: 'Filosofi Teras',
    genre: 'Filsafat',
    hargaPinjam: 5000.0,
    coverImage: 'assets/images/coverFilosofiTeras.png',
    sinopsis:
        'Sebuah buku pengantar filsafat Stoa yang dibuat khusus sebagai panduan moral anak muda.',
  ),
  Book(
    id: 2,
    judul: 'Bumi',
    genre: 'Fantasi',
    hargaPinjam: 3000.0,
    coverImage: 'assets/images/coverBumi.png',
    sinopsis:
        'Serial ini mengikuti petualangan tiga sahabat, Raib, Seli, dan Ali, yang menemukan dunia paralel dengan teknologi mutakhir, berbeda dengan genre fantasi seperti Harry Potter.',
  ),
  Book(
    id: 3,
    judul: 'Negeri Para Bedebah',
    genre: 'Komik',
    hargaPinjam: 4500.0,
    coverImage: 'assets/images/coverNegeriParaBedebah.png',
    sinopsis:
        'Berkisah tentang Thomas, seorang konsultan keuangan brilian yang harus berjuang membersihkan nama baik keluarganya di tengah skandal besar yang mengguncang negeri.',
  ),
  // Book(id: 4, judul: 'Home Sweet Loan', genre: 'Kehidupan', hargaPinjam: 2000.0, coverImage:'assets/images/coverHomeSL.png', sinopsis: 'Empat orang yang berteman sejak SMA bekerja di perusahaan yang sama meski beda nasib. Di usia 31 tahun, mereka berburu rumah idaman yang minimal nyerempet Jakarta.'),
];
