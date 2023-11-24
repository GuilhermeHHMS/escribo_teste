import 'package:ebook_escribo/models/book_model.dart';
import 'package:ebook_escribo/views/components/book_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:ebook_escribo/controllers/book_controller.dart';

import 'components/book_dialogs_components.dart';

class FavoriteBooksScreen extends StatefulWidget {
  const FavoriteBooksScreen({super.key});

  @override
  State<FavoriteBooksScreen> createState() => _FavoriteBooksScreenState();
}

class _FavoriteBooksScreenState extends State<FavoriteBooksScreen> {
  final BookController _bookController = BookController();
  final BookCacheHandler _bookCacheHandler = BookCacheHandler();
  List<Book> favoriteBooks = [];
  bool isLoaded = false;
  @override
  void initState() {
    _loadFavoriteBooks();
    super.initState();
  }

  Future<void> _loadFavoriteBooks() async {
    List<Book>? allBooks = await _bookCacheHandler.loadSavedFavoritesState();
    if (allBooks != null) {
      setState(() {
        favoriteBooks = allBooks.where((book) => book.isFavorite).toList();
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double textScale = MediaQuery.textScaleFactorOf(context);

    return favoriteBooks.isNotEmpty
        ? BookGridView(
            showLoader: isLoaded,
            books: favoriteBooks,
            onTap: (Book book) {
              BookDialogHelper.showBookOptions(
                context,
                favoriteBooks,
                favoriteBooks.indexOf(book),
              );
            },
            onFavoritePressed: (Book book) {
              setState(() {
                _bookController.toggleFavorite(
                    favoriteBooks, favoriteBooks.indexOf(book));
                debugPrint(book.isFavorite.toString());
              });
            },
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Nenhum livro salvo.',
                  textScaleFactor: textScale * 2,
                  style: const TextStyle(color: Colors.grey),
                ),
                Icon(
                  Icons.emoji_nature_outlined,
                  size: textScale * 45,
                  color: Colors.grey,
                )
              ],
            ),
          );
  }
}
