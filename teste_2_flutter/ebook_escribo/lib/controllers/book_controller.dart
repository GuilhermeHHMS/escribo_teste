import 'dart:convert';

import 'package:ebook_escribo/services/api_service.dart';
import 'package:ebook_escribo/models/book_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookController {
  final ApiService _apiService = ApiService();

  Future<List<Book>?> getBooks() async {
    try {
      List<Book>? newBooks = await _apiService.fetchBooks() ?? [];
      List<Book>? cacheBooks = await loadSavedFavoritesState() ?? [];

      Set<int> shelfFilter = cacheBooks.map((book) => book.id).toSet();

      List<Book> filteredBooks =
          newBooks.where((book) => !shelfFilter.contains(book.id)).toList();

      List<Book> mergedBooks = [...cacheBooks, ...filteredBooks];
      _saveFavoritesState(
          mergedBooks.map((book) => jsonEncode(book.toJson())).toList());

      return mergedBooks;
    } catch (e) {
      Fluttertoast.showToast(msg: 'Não foi possivel carregar livros: $e');
    }
    return null;
  }

  void toggleFavorite(List<Book> bookShelf, int index) {
    bookShelf[index].isFavorite = !bookShelf[index].isFavorite;
    _saveFavoritesState(
        bookShelf.map((book) => jsonEncode(book.toJson())).toList());
  }

  Future<List<Book>?> loadSavedFavoritesState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? savedData = prefs.getStringList('favorites');
    if (savedData != null) {
      return savedData
          .map((jsonString) => Book.fromJson(jsonDecode(jsonString)))
          .toList();
    }
    return null;
  }

  Future<void> _saveFavoritesState(List<String> favoriteList) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? favoriteData =
        favoriteList.map((fav) => fav.toString()).toList();
    prefs.setStringList('favorites', favoriteData);
  }
}
