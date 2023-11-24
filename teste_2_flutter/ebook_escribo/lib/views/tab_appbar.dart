import 'package:ebook_escribo/views/books_shelf_screen.dart';
import 'package:ebook_escribo/views/favorite_books_screen.dart';
import 'package:flutter/material.dart';

class EBookTabView extends StatefulWidget {
  const EBookTabView({super.key});

  @override
  State<EBookTabView> createState() => _EBookTabViewState();
}

class _EBookTabViewState extends State<EBookTabView> {
  @override
  Widget build(BuildContext context) {
    const List<Tab> tabs = [
      Tab(
        icon: Icon(Icons.book),
        text: 'catálogo de livros',
      ),
      Tab(
        icon: Icon(Icons.bookmark_outlined),
        text: 'Favoritos',
      ),
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: tabs,
          ),
        ),
        body: const TabBarView(
          children: [
            BookShelfScreen(),
            FavoriteBooksScreen(),
          ],
        ),
      ),
    );
  }
}
