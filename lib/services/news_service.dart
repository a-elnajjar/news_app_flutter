import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class NewsService {
  final String _newsApiKey = '';
  final String _newsApiBaseUrl = 'https://newsapi.org/v2';
  final String _newsDataApiKey = '';
  final String _newsDataApiBaseUrl = 'https://newsdata.io/api/1/news';

  Future<List<Article>> fetchTopHeadlines({String country = 'us', int page = 1, int pageSize = 20}) async {
    final List<Article> articles = [];

    // Fetch articles from NewsAPI
    final Uri newsApiUrl = Uri.parse('$_newsApiBaseUrl/top-headlines?country=$country&apiKey=$_newsApiKey&page=$page&pageSize=$pageSize');
    try {
      final http.Response response = await http.get(newsApiUrl);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'ok') {
          articles.addAll((data['articles'] as List).map((json) => Article.fromJson(json)).toList());
        } else {
          throw Exception('Failed to fetch articles: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load news: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching news from NewsAPI: $e');
    }

    // Fetch articles from NewsData.io
    final Uri newsDataApiUrl = Uri.parse('$_newsDataApiBaseUrl?apikey=$_newsDataApiKey&country=$country&page=$page&pageSize=$pageSize');
    try {
      final http.Response response = await http.get(newsDataApiUrl);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        articles.addAll((data['results'] as List).map((json) => Article.fromJson(json)).toList());
      } else {
        throw Exception('Failed to load news: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching news from NewsData.io: $e');
    }

    return articles;
  }
}
