import 'package:ebook_escribo/services/api_service.dart';
import 'package:ebook_escribo/models/book_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookController {
  final ApiService _apiService = ApiService();

  Future<List<Book>?> getBooks() async {
    try {
      List<Book>? filteredBooks = await _apiService.fetchBooks();

      return filteredBooks;
    } catch (e) {
      Fluttertoast.showToast(msg: 'Não foi possivel carregar livros: $e');

      print(e);
    }
    return null;
  }

  void toggleFavorite(List<Book> bookShelf, int index) {
    bookShelf[index].isFavorite = !bookShelf[index].isFavorite;
    _saveFavoritesState(bookShelf.map((book) => book.isFavorite).toList());
  }

  Future<List<bool>?> loadSavedFavoritesState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? savedData = prefs.getStringList('favorites');
    if (savedData != null) {
      return savedData.map((fav) => bool.fromEnvironment(fav)).toList();
    }
    return null;
  }

  Future<void> _saveFavoritesState(List<bool> favoriteList) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? favoriteData =
        favoriteList.map((fav) => fav.toString()).toList();
    prefs.setStringList('favorites', favoriteData);
  }
}
