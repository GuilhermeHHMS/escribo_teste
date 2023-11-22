import 'package:ebook_escribo/views/home_page_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const EBookApp());
}

class EBookApp extends StatelessWidget {
  const EBookApp({super.key});
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
