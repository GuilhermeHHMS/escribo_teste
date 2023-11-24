import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
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

      if (cacheBooks.isNotEmpty) {
        Set<int> shelfFilter = cacheBooks.map((book) => book.id).toSet();

        List<Book> filteredBooks =
            newBooks.where((book) => !shelfFilter.contains(book.id)).toList();

        List<Book> mergedBooks = [...cacheBooks, ...filteredBooks];
        _saveFavoritesState(
            mergedBooks.map((book) => jsonEncode(book.toJson())).toList());

        return mergedBooks;
      } else {
        return newBooks;
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg:
              'Não foi posível carregar dados. Verifique sua conexão com a internet.');
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

    final List<String> savedData = prefs.getStringList('favorites') ?? [];
    if (savedData.isNotEmpty) {
      try {
        return savedData
            .map((jsonString) => Book.fromJson(jsonDecode(jsonString)))
            .toList();
      } catch (e) {
        return [];
      }
    } else {
      return [];
    }
  }

  Future<void> _saveFavoritesState(List<String> favoriteList) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? favoriteData =
        favoriteList.map((fav) => fav.toString()).toList();
    prefs.setStringList('favorites', favoriteData);
  }

  Future<bool> downloadBook(List<Book> bookShelf, int index) async {
    bool isDownloaded = false;
    Dio dio = Dio();
    Directory? appDir = await getExternalStorageDirectory();

    String epubPath = '${appDir!.path}/${bookShelf[index].title}.epub';
    
    File file = File(epubPath);

    if (!file.existsSync()) {
      await dio
          .download(
            bookShelf[index].downloadUrl,
            epubPath,
            deleteOnError: true,
          )
          .whenComplete(() {
            bookShelf[index].epubPath = epubPath;
           _saveFavoritesState(bookShelf.map((book) => jsonEncode(book.toJson())).toList());
            print('DOWNLOAD CONCLUÍDO');
          });
      isDownloaded = true;
      return isDownloaded;
    } else {
      print('O arquivo já existe');
      return isDownloaded = true;
    }
  }

   Future<bool> isBookDownloaded(Book book) async {

    Directory? appDir = await getExternalStorageDirectory();
    String filePath = '${appDir!.path}/${book.title}.epub';

    return File(filePath).existsSync();
  }
}
