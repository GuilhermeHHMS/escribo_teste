import 'package:ebook_escribo/controllers/book_controller.dart';
import 'package:ebook_escribo/models/book_model.dart';
import 'package:ebook_escribo/views/components/book_card.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'book_dialogs_components.dart';

class BookGridView extends StatefulWidget {
  final List<Book> books;
  final Function(Book) onTap;
  final Function(Book) onFavoritePressed;
  final bool showLoader;

  const BookGridView({
    super.key,
    required this.books,
    required this.onTap,
    required this.onFavoritePressed,
    this.showLoader = false,
  });

  @override
  State<BookGridView> createState() => _BookGridViewState();
}

class _BookGridViewState extends State<BookGridView> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = (screenWidth / 200).floor();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: widget.books.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
              itemCount: widget.books.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: .75,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
              ),
              itemBuilder: (context, index) {
                Book book = widget.books[index];

                return BookCard(
                  book: book,
                  onTap:() => widget.onTap(book),
                  onFavoritePressed: () {
                    widget.onFavoritePressed(book);
                  },
                  isFavorite: book.isFavorite,
                );
              },
            ),
    );
  }

  
}
