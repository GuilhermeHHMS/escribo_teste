import 'package:ebook_escribo/services/api_service.dart';
import 'package:ebook_escribo/models/book_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  void toggleFavorite(bool isFavorite) {
    isFavorite = !isFavorite;
  }
}
