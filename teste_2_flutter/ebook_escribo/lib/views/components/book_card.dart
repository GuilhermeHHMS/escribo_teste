import 'package:ebook_escribo/models/book_model.dart';
import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoritePressed;

  const BookCard({
    super.key,
    required this.book,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoritePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        alignment: Alignment.center,
        children: [
          InkWell(
            onTap: onTap,
            child: SizedBox.expand(
              child: Column(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Image.network(book.coverUrl),
                    ),
                  ),
                  ListTile(
                    title: Text(book.title, style: TextStyle(fontWeight: FontWeight.bold),),
                    subtitle: Text('by: ${book.author}'),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: .0,
            right: 0.0,
            child: InkWell(
              onTap: onFavoritePressed,
              child: Icon(
                book.isFavorite ? Icons.bookmark : Icons.bookmark_border,
                color: book.isFavorite ? Colors.red : Colors.black,
                size: 34.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
