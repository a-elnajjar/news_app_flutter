import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class NewsService {
  final String apiKey = '';
  final String baseUrl = 'https://newsapi.org/v2';

  Future<List<Article>> fetchTopHeadlines({String country = 'us', int page = 1, int pageSize = 20}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/top-headlines?country=$country&apiKey=$apiKey&page=$page&pageSize=$pageSize')
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      List<Article> articles = (data['articles'] as List).map((json) => Article.fromJson(json)).toList();
      return articles;
    } else {
      throw Exception('Failed to load news');
    }
  }
}
