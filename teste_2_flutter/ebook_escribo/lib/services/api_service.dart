import 'package:ebook_escribo/models/book_model.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ApiService {
  Future<List<Book>?> fetchBooks() async {
    const kAPI = 'https://escribo.com/books.json';

    try {
      Dio dio = Dio();
      final response = await dio.get(kAPI);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;

        return jsonList
            .map(
              (json) => Book(
                id: json['id'],
                title: json['title'],
                author: json['author'],
                coverUrl: json['cover_url'],
                downloadUrl: json['download_url'],
              ),
            )
            .toList();
      } else {
        Fluttertoast.showToast(msg: 'Não foi possível recuperar dados da API.');
      }
    } catch (e) {
      throw Exception('Erro durante a requisição: $e');
    }
    return null;
  }
}
