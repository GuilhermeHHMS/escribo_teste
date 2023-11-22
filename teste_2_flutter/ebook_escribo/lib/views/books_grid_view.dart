import 'package:ebook_escribo/controllers/book_controller.dart';
import 'package:ebook_escribo/models/book_model.dart';
import 'package:ebook_escribo/views/components/book_item.dart';
import 'package:flutter/material.dart';

class BookShelfGridView extends StatefulWidget {
  const BookShelfGridView({super.key});

  @override
  State<BookShelfGridView> createState() => _BookShelfGridViewState();
}

class _BookShelfGridViewState extends State<BookShelfGridView> {
  final BookController _bookController = BookController();
  List<Book> bookShelf = [];

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
      });
    } catch (error) {
      print('Erro ao carregar dados: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = (screenWidth / 200).floor();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: bookShelf.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
              itemCount: bookShelf.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: .75,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
              ),
              itemBuilder: (context, index) {
                Book book = bookShelf[index];

                return BookCard(
                  book: book,
                  onTap: () {},
                  onFavoritePressed: () {
                    setState(() {
                      _bookController.toggleFavorite(bookShelf, index);
                      print(book.isFavorite);
                    });
                  },
                  isFavorite: book.isFavorite,
                );
              },
            ),
    );
  }
}
