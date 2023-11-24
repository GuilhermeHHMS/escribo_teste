import 'package:flutter/material.dart';
import '../../controllers/book_controller.dart';
import '../../models/book_model.dart';

class BookDialogHelper {
  static void showBookOptions(
      BuildContext context, List<Book> bookShelf, int index) async {
    BookController bookController = BookController();
    bool isBookDownloaded =
        await bookController.isBookDownloaded(bookShelf[index]);

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) {
          Book book = bookShelf[index];
          return Center(
            child: Dialog(
              child: Container(
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text(
                        book.title,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text('by: ${book.author}'),
                    ),
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 15),
                        child: Image.network(
                          book.coverUrl,
                          scale: .5,
                        ),
                      ),
                    ),
                    isBookDownloaded
                        ? ElevatedButton(
                            child: const Text('Visualizar'),
                            onPressed: () {
                              bookController.bookViewer(book);
                            })
                        : ElevatedButton(
                            child: const Text('Baixar'),
                            onPressed: () {
                              _showProgressDialog(context);

                              bookController
                                  .downloadBook(
                                      bookShelf, bookShelf.indexOf(book))
                                  .then((_) {
                                Navigator.pop(context);
                              }).whenComplete(() {
                                Navigator.pop(context);
                                bookController.bookViewer(book);
                              });
                            },
                          ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }

  static void _showProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: SizedBox(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Baixando'),
              CircularProgressIndicator(),
            ],
          )),
        );
      },
    );
  }
}
