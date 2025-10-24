import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/article.dart';

class NewsServiceException implements Exception {
  NewsServiceException(this.message);

  final String message;

  @override
  String toString() => 'NewsServiceException: $message';
}

class NewsService {
  NewsService({http.Client? client, String? apiKey})
      : _client = client ?? http.Client(),
        _newsApiKey = apiKey ?? const String.fromEnvironment('NEWS_API_KEY');

  final http.Client _client;
  final String _newsApiKey;
  static const String _newsApiBaseUrl = 'newsapi.org';

  Future<List<Article>> fetchTopHeadlines({
    String country = 'us',
    int page = 1,
    int pageSize = 20,
    String? query,
  }) async {
    if (_newsApiKey.isEmpty) {
      throw NewsServiceException(
        'A News API key is required. Set the NEWS_API_KEY environment value or pass it to NewsService.',
      );
    }

    final queryParameters = <String, String>{
      'country': country,
      'apiKey': _newsApiKey,
      'page': '$page',
      'pageSize': '$pageSize',
    };

    if (query != null && query.trim().isNotEmpty) {
      queryParameters['q'] = query.trim();
    }

    final uri = Uri.https(_newsApiBaseUrl, '/v2/top-headlines', queryParameters);

    try {
      final response = await _client.get(uri);
      if (response.statusCode != 200) {
        throw NewsServiceException(
          'Failed to load news: HTTP ${response.statusCode} ${response.reasonPhrase ?? ''}'.trim(),
        );
      }

      final Map<String, dynamic> data = json.decode(response.body) as Map<String, dynamic>;
      if (data['status'] != 'ok') {
        throw NewsServiceException('Failed to fetch articles: ${data['message']}');
      }

      final articlesJson = data['articles'] as List<dynamic>?;
      if (articlesJson == null) {
        return const [];
      }

      return articlesJson
          .whereType<Map<String, dynamic>>()
          .map(Article.fromJson)
          .toList(growable: false);
    } on http.ClientException catch (error) {
      throw NewsServiceException('Network error while fetching news: $error');
    } on FormatException catch (error) {
      throw NewsServiceException('Invalid response from news service: $error');
    }
  }
}
