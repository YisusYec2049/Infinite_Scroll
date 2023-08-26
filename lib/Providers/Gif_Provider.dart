import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/ModeloGif.dart';

class GifProvider {
  final url =
      'https://api.giphy.com/v1/gifs/trending?api_key=081Z33Gf8OaNbdK1upYCzUqPGG90MimV&rating=g ';

  Future<List<ModeloGif>> getMoreGifs(int perpage, int startIndex) async {
    try {
      final resp = await http.get(Uri.parse(url));

      if (resp.statusCode == 200) {
        final jsonData = json.decode(resp.body);
        final gifsData = jsonData['data'] as List<dynamic>;

        final newGifs = gifsData.map((gifData) {
          return ModeloGif.fromJson(gifData);
        }).toList();

        return newGifs;
      } else {
        throw Exception('Failed to load more gifs');
      }
    } catch (e) {
      throw Exception('Failed to load gifs: $e');
    }
  }
}
