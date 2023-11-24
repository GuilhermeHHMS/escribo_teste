import 'package:ebook_escribo/controllers/book_controller.dart';
import 'package:ebook_escribo/models/book_model.dart';
import 'package:ebook_escribo/views/components/book_grid_view.dart';
import 'package:flutter/material.dart';

import 'components/book_dialogs_components.dart';

class BookShelfScreen extends StatefulWidget {
  const BookShelfScreen({Key? key}) : super(key: key);

  @override
  State<BookShelfScreen> createState() => _BookShelfScreenState();
}

class _BookShelfScreenState extends State<BookShelfScreen> {
  final BookController _bookController = BookController();
  List<Book> bookShelf = [];
  bool isLoaded = false;

  @override
  void initState() {
    _loadBooks();

    super.initState();
  }

  Future<void> _loadBooks() async {
    try {
      List<Book>? books = await _bookController.getBooks();
      setState(() {
        bookShelf = books!;
        isLoaded = true;
      });
    } catch (error) {
      debugPrint('Erro ao carregar dados: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BookGridView(
      showLoader: isLoaded,
      books: bookShelf,
      onTap: (Book book) {
        BookDialogHelper.showBookOptions(
          context,
          bookShelf,
          bookShelf.indexOf(book),
        );
      },
      onFavoritePressed: (Book book) {
        setState(() {
          _bookController.toggleFavorite(bookShelf, bookShelf.indexOf(book));
          debugPrint(book.isFavorite.toString());
        });
      },
    );
  }
}
