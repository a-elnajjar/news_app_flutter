import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class NewsService {
  final String _apiKey = ''; 
  final String _baseUrl = 'https://newsapi.org/v2';

  Future<List<Article>> fetchTopHeadlines({String country = 'us', int page = 1, int pageSize = 20}) async {
    final Uri url = Uri.parse('$_baseUrl/top-headlines?country=$country&apiKey=$_apiKey&page=$page&pageSize=$pageSize');
    try {
      final http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'ok') {
          List<Article> articles = (data['articles'] as List).map((json) => Article.fromJson(json)).toList();
          return articles;
        } else {
          throw Exception('Failed to fetch articles: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load news: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Log the error or handle it appropriately
      print('Error fetching news: $e');
      throw Exception('Failed to load news');
    }
  }
}
