import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ebook_escribo/controllers/permission_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:ebook_escribo/services/api_service.dart';
import 'package:ebook_escribo/models/book_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';

class BookCacheHandler {
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

  Future<void> saveFavoritesState(List<String> favoriteList) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? favoriteData =
        favoriteList.map((fav) => fav.toString()).toList();
    prefs.setStringList('favorites', favoriteData);
  }
}

class BookController {
  final ApiService _apiService = ApiService();
  final BookCacheHandler _bookCacheHandler = BookCacheHandler();

  Future<List<Book>?> getBooks() async {
    try {
      List<Book>? newBooks = await _apiService.fetchBooks() ?? [];

      List<Book>? cacheBooks =
          await _bookCacheHandler.loadSavedFavoritesState() ?? [];

      if (cacheBooks.isNotEmpty) {
        Set<int> shelfFilter = cacheBooks.map((book) => book.id).toSet();

        List<Book> filteredBooks =
            newBooks.where((book) => !shelfFilter.contains(book.id)).toList();

        List<Book> mergedBooks = [...cacheBooks, ...filteredBooks];
        _bookCacheHandler.saveFavoritesState(
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
    _bookCacheHandler.saveFavoritesState(
        bookShelf.map((book) => jsonEncode(book.toJson())).toList());
  }

  Future<bool> downloadBook(List<Book> bookShelf, int index) async {
    Directory? appDir = await getExternalStorageDirectory();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    PermissionController permissionController = PermissionController();

    bool isDownloaded = false;
    Dio dio = Dio();

    bool? isGranted = prefs.getBool('storagePermission') ?? false;

    String epubPath = '${appDir!.path}/${bookShelf[index].title}.epub';

    File file = File(epubPath);

    if (!file.existsSync()) {
      isGranted = await permissionController.downloadPermissionAuth();
      if (isGranted == true) {
        await dio
            .download(
          bookShelf[index].downloadUrl,
          epubPath,
          deleteOnError: true,
        )
            .whenComplete(() {
          bookShelf[index].epubPath = epubPath;
          _bookCacheHandler.saveFavoritesState(
              bookShelf.map((book) => jsonEncode(book.toJson())).toList());
          Fluttertoast.showToast(msg: 'Livro baixado com sucesso');
        });
        isDownloaded = true;
        return isDownloaded;
      }
      Fluttertoast.showToast(msg: 'Permissão de armazenamento negada');
      isDownloaded = true;
      return isDownloaded;
    } else {
      isDownloaded = true;
      return isDownloaded;
    }
  }

//Metodo responsável por exibir o visualizador do pacote "vocsy_epub_viewer".
  void bookViewer(Book book) {
    VocsyEpub.setConfig(
      scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
      allowSharing: true,
      enableTts: true,
      nightMode: true,
    );

    //visualizar somente livros baixados.
    VocsyEpub.open(
      book.epubPath ?? '',
    );
  }

  Future<bool> isBookDownloaded(Book book) async {
    Directory? appDir = await getExternalStorageDirectory();
    String filePath = '${appDir!.path}/${book.title}.epub';

    return File(filePath).existsSync();
  }
}
