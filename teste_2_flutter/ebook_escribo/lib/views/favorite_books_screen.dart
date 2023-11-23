import 'package:ebook_escribo/models/book_model.dart';
import 'package:ebook_escribo/views/components/book_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:ebook_escribo/controllers/book_controller.dart';

class FavoriteBooksScreen extends StatefulWidget {
  const FavoriteBooksScreen({super.key});

  @override
  State<FavoriteBooksScreen> createState() => _FavoriteBooksScreenState();
}

class _FavoriteBooksScreenState extends State<FavoriteBooksScreen> {
  final BookController _bookController = BookController();
  List<Book> favoriteBooks = [];
  bool isLoaded = false;
  @override
  void initState() {
    _loadFavoriteBooks();
    super.initState();
  }

  Future<void> _loadFavoriteBooks() async {
    List<Book>? allBooks = await _bookController.loadSavedFavoritesState();
    if (allBooks != null) {
      setState(() {
        favoriteBooks = allBooks.where((book) => book.isFavorite).toList();
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BookGridView(
      showLoader: isLoaded,
      books: favoriteBooks,
      onFavoritePressed: (Book book) {
        setState(() {
          _bookController.toggleFavorite(
              favoriteBooks, favoriteBooks.indexOf(book));
          print(book.isFavorite);
        });
      },
    );
  }
}
