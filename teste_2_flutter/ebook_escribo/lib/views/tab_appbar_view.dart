import 'package:ebook_escribo/views/books_grid_view.dart';
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
        icon: Icon(Icons.favorite),
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
        body: TabBarView(
          children: [
            BookShelfGridView(),
            const Center(
              child: Text('Esse é o tab de favoritos'),
            ),
          ],
        ),
      ),
    );
  }
}
