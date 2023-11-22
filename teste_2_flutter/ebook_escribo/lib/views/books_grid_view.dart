import 'package:ebook_escribo/controllers/book_controller.dart';
import 'package:ebook_escribo/models/book_model.dart';
import 'package:ebook_escribo/views/components/book_item.dart';
import 'package:flutter/material.dart';

class BookShelfGridView extends StatelessWidget {
  BookShelfGridView({super.key});
  final BookController _bookController = BookController();

  @override
  Widget build(BuildContext context) {
    bool isFavorite = false;
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = (screenWidth / 200).floor();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder<List<Book>?>(
        future: _bookController.getBooks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Erro ao carregar dados: ${snapshot.error}');
          } else {
            List<Book> bookShelf = snapshot.data ?? [];

            if (bookShelf.isEmpty) {
              return const Center(
                child: Text('Nenhum livro disponível.'),
              );
            }
            return GridView.builder(
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
                  onFavoritePressed: () =>
                      _bookController.toggleFavorite(isFavorite),
                  isFavorite: isFavorite,
                );
              },
            );
          }
        },
      ),
    );
  }
}
