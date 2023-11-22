import 'package:ebook_escribo/models/tab_appbar_model.dart';
import 'package:flutter/material.dart';

class EBookTabView extends StatefulWidget {
  const EBookTabView({super.key});

  @override
  State<EBookTabView> createState() => _EBookTabViewState();
}

class _EBookTabViewState extends State<EBookTabView> { 

  @override
  Widget build(BuildContext context) {

    TabAppBarModel _tabAppBarModel = const TabAppBarModel(
      tabBarIcons: [
        Tab(icon: Icon(Icons.book)),
        Tab(icon: Icon(Icons.favorite)),
      ],
      tabBarTitles: [
        'Catalogo de livros',
        'Favoritos',
      ],
    );

    return DefaultTabController(
  
      length: _tabAppBarModel.tabBarIcons.length,
      child: Scaffold(
        appBar: AppBar(
        
          bottom: TabBar(
            tabs: _tabAppBarModel.tabBarIcons,
            
          ),
        ),
        body: const TabBarView(
          
          children: [
            Center(child: Text('Esse é o tab de livros')),
            Center(child: Text('Esse é o tab de favoritos')),
          ],

        ),
      ),
    );
  }
}
