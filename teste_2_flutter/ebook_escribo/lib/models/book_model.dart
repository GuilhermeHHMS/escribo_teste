class Book {
  final int id;
  final String title;
  final String author;
  final String coverUrl;
  final String downloadUrl;
  String? epubPath;
  bool isFavorite;
  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.coverUrl,
    required this.downloadUrl,
    this.epubPath,
    this.isFavorite = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'cover_url': coverUrl,
      'download_url': downloadUrl,
      'is_favorite': isFavorite,
      'epub_path': epubPath,
    };
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
        id: json['id'],
        title: json['title'],
        author: json['author'],
        coverUrl: json['cover_url'],
        downloadUrl: json['download_url'],
        isFavorite: json['is_favorite'],
        epubPath: json['epub_path']);
  }
}
