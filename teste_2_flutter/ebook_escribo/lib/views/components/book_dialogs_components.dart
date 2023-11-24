import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';

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
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      child: Image.network(book.coverUrl),
                    ),
                    isBookDownloaded
                        ? ElevatedButton(
                            child: Text('Visualizar'),
                            onPressed: () async {
                              VocsyEpub.setConfig(
                                themeColor: Theme.of(context).primaryColor,
                                scrollDirection:
                                    EpubScrollDirection.ALLDIRECTIONS,
                                allowSharing: true,
                                enableTts: true,
                                nightMode: true,
                              );
                              // get current locator
                              VocsyEpub.locatorStream.listen((locator) {
                                print('LOCATOR: $locator');
                              });
                              VocsyEpub.open(
                                book.epubPath ?? '',
                              );
                            })
                        : ElevatedButton(
                            child: Text('Baixar'),
                            onPressed: () {
                              _showProgressDialog(context);

                              bookController
                                  .downloadBook(
                                      bookShelf, bookShelf.indexOf(book))
                                  .then((_) {
                                Navigator.pop(context);
                                Fluttertoast.showToast(
                                    msg: 'Download concluído');
                              }).whenComplete(() => Navigator.pop(context));
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
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
